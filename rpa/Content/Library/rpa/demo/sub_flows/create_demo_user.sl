########################################################################################################################
#!!
#! @description: Creates a user and setups her workspace; it deploys CPs into dependencies and imports the GIT repository
#!
#! @input token: IDM token
#! @input ws_user: Which user to create
#! @input ws_password: Password of the newly created user; if not given, the default RPA admin password will be used
#! @input ws_tenant: RPA tenant the newly user will belong to; if not given, the default tenant will be used
#! @input org_id: RPA tenant ID the newly user will belong to
#! @input group_id: IDM group the user will belong to; if empty; the user will not be assigned anywhere
#! @input repre_name: Representation name
#! @input cp_files: List of full path to CPs to be deployed into the user workspace
#! @input scm_url: SCM repository URL to be imported
#! @input reset_user: If true, the user's account (if exists) will get removed including the user's workspace; there is no way to recover
#!
#! @output cp_status_json: Status of last CP import
#! @output repo_status_json: Status of SCM repository import
#! @output failure: Empty if no error appeared; will contain what has failed otherwise
#!!#
########################################################################################################################
namespace: rpa.demo.sub_flows
flow:
  name: create_demo_user
  inputs:
    - token
    - ws_user
    - ws_password:
        required: false
        sensitive: true
    - ws_tenant:
        required: false
    - org_id:
        required: true
    - group_id:
        required: true
    - repre_name:
        required: true
    - cp_files:
        required: false
    - scm_url:
        required: false
    - reset_user:
        required: false
  workflow:
    - get_user:
        do:
          rpa.idm.rest.user.get_user:
            - token: '${token}'
            - username_or_id: '${ws_user}'
            - org_id: '${org_id}'
        publish:
          - user_json
        navigate:
          - FAILURE: add_user
          - SUCCESS: reset_user
    - add_user:
        do:
          rpa.idm.rest.user.add_user:
            - token: '${token}'
            - username: '${ws_user}'
            - password: "${get('ws_password', get_sp('rpa_password'))}"
            - org_id: '${org_id}'
        publish:
          - user_json
          - user_id: "${eval(user_json)['abstractUserId']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: assign_users
    - assign_users:
        do:
          rpa.idm.rest.representation.assign_users:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_id: '${group_id}'
            - repre_name: '${repre_name}'
            - new_user_ids: "${'[\"%s\"]' % user_id}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_token
    - get_default_ws_id:
        do:
          rpa.designer.rest.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: no_ws_yet
    - get_token:
        do:
          rpa.designer.rest.authenticate.get_token:
            - ws_user: '${ws_user}'
            - ws_password: "${get('ws_password', get_sp('rpa_password'))}"
            - ws_tenant: "${get('ws_tenant', get_sp('idm_tenant'))}"
        publish:
          - designer_token: '${token}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - import_and_assign_cp:
        loop:
          for: cp_file in eval(cp_files)
          do:
            rpa.demo.sub_flows.import_and_assign_cp:
              - token: '${designer_token}'
              - cp_file: '${cp_file}'
              - ws_id: '${ws_id}'
          break:
            - FAILURE
          publish:
            - cp_status_json: '${status_json}'
            - failure: ''
        navigate:
          - FAILURE: import_cp_failed
          - SUCCESS: is_repo_given
    - no_ws_yet:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(ws_id) == 0)}'
        navigate:
          - 'TRUE': create_workspace
          - 'FALSE': is_cp_files_given
    - create_workspace:
        do:
          rpa.designer.rest.workspace.create_workspace:
            - token: '${designer_token}'
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_cp_files_given
    - import_repo:
        do:
          rpa.designer.rest.repository.import_repo:
            - token: '${designer_token}'
            - ws_id: '${ws_id}'
            - scm_url: '${scm_url}'
        publish:
          - repo_status_json: '${status_json}'
        navigate:
          - FAILURE: import_scm_failed
          - SUCCESS: logout
    - reset_user:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${reset_user}'
            - second_string: 'true'
            - ignore_case: 'true'
            - user_json: '${user_json}'
        publish:
          - user_id: "${eval(user_json)['id']}"
        navigate:
          - SUCCESS: get_old_user_token
          - FAILURE: assign_users
    - delete_user:
        do:
          rpa.idm.rest.user.delete_user:
            - token: '${token}'
            - username_or_id: '${ws_user}'
            - org_id: '${org_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_user
    - is_cp_files_given:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(cp_files) > 0)}'
        navigate:
          - 'TRUE': import_and_assign_cp
          - 'FALSE': is_repo_given
    - is_repo_given:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(scm_url) > 0)}'
        navigate:
          - 'TRUE': import_repo
          - 'FALSE': logout
    - get_old_user_token:
        do:
          rpa.designer.rest.authenticate.get_token:
            - ws_user: '${ws_user}'
            - ws_password: "${get('ws_password', get_sp('rpa_password'))}"
            - ws_tenant: "${get('ws_tenant', get_sp('idm_tenant'))}"
        publish:
          - designer_token: '${token}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_old_user_ws_id
    - get_old_user_ws_id:
        do:
          rpa.designer.rest.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: has_ws
    - delete_workspace:
        do:
          rpa.designer.rest.workspace.delete_workspace:
            - token: '${designer_token}'
            - ws_id: '${ws_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_user
    - import_cp_failed:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
        publish:
          - failure: import_cp
        navigate:
          - SUCCESS: is_repo_given
          - FAILURE: on_failure
    - import_scm_failed:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
            - failure: '${failure}'
        publish:
          - failure: '${("" if failure == "" else failure+",")+"import_scm"}'
        navigate:
          - SUCCESS: logout
          - FAILURE: on_failure
    - logout:
        do:
          rpa.designer.rest.authenticate.logout: []
        navigate:
          - SUCCESS: has_any_failure
    - has_ws:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(ws_id)>0)}'
        navigate:
          - 'TRUE': delete_workspace
          - 'FALSE': delete_user
    - has_any_failure:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(failure)>0)}'
        navigate:
          - 'TRUE': INCOMPLETE
          - 'FALSE': SUCCESS
    - on_failure:
        - logout_on_failure:
            do:
              rpa.designer.rest.authenticate.logout: []
  outputs:
    - cp_status_json: '${cp_status_json}'
    - repo_status_json: '${repo_status_json}'
    - failure: '${failure}'
  results:
    - SUCCESS
    - FAILURE
    - INCOMPLETE
extensions:
  graph:
    steps:
      has_ws:
        x: 151
        'y': 312
      delete_workspace:
        x: 244
        'y': 164
      no_ws_yet:
        x: 396
        'y': 26
      is_repo_given:
        x: 775
        'y': 27
      get_old_user_token:
        x: 66
        'y': 162
      add_user:
        x: 7
        'y': 587
      logout:
        x: 925
        'y': 208
      get_old_user_ws_id:
        x: 65
        'y': 447
      import_repo:
        x: 885
        'y': 386
      get_token:
        x: 536
        'y': 585
      has_any_failure:
        x: 1059
        'y': 26
        navigate:
          9b06e9f9-1b46-42fc-d712-eed46a669fcc:
            targetId: 9d4b168c-3e38-426a-b2db-623d9688c667
            port: 'FALSE'
          445eb91c-c85c-5e0c-1d8c-0e24120e065e:
            targetId: 25309fda-edd2-c51d-a005-9b3bfb65b0c9
            port: 'TRUE'
      create_workspace:
        x: 503
        'y': 382
      get_user:
        x: 6
        'y': 72
      import_cp_failed:
        x: 783
        'y': 385
      get_default_ws_id:
        x: 397
        'y': 429
      is_cp_files_given:
        x: 590
        'y': 27
      assign_users:
        x: 302
        'y': 585
      import_scm_failed:
        x: 1055
        'y': 385
      reset_user:
        x: 302
        'y': 71
      import_and_assign_cp:
        x: 621
        'y': 386
      delete_user:
        x: 244
        'y': 461
    results:
      SUCCESS:
        9d4b168c-3e38-426a-b2db-623d9688c667:
          x: 892
          'y': 28
      INCOMPLETE:
        25309fda-edd2-c51d-a005-9b3bfb65b0c9:
          x: 1057
          'y': 203
