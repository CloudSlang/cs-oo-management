########################################################################################################################
#!!
#! @description: Creates users and setups their workspace; it deploys CPs into dependencies and imports the GitHub repository
#!
#! @input users_json: A JSON doc that contains a list of items, each item in the list has 3 mandatory properties: user, scm_url and cp_files. scm_url and cp_files might be empty but must be given. user contains the username to be created; scm_url contains the GIT repository URL which will be imported and cp_files contains a list of string values, each value is the full path (pointing where RPA is running); these files will be imported to the user dependencies.
#! @input users_password: Password set to all the newly created users; if not given, default RPA admin password is used
#! @input org_name: Tenant name the users will belong to; the default tenant if not given
#! @input group_name: Group the users will be added to
#! @input repre_prefix: Prefix added to representation name
#! @input reset_user: If true, the user's account (if exists) will get removed including user's workspace; there is no way to recover
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: create_demo_users
  inputs:
    - users_json: "${'''\n{\n    \"cp_folder\": \"C:\\\\\\\\Users\\\\\\\\Administrator\\\\\\\\Downloads\\\\\\\\content-packs\",\n    \"users\": [\n      {\n        \"user\": \"aosdev\",\n        \"github_repo\": \"pe-pan/rpa-aos\",\n        \"update_binaries\": \"yes\",\n        \"cp_files\": [\n          \"oo10-base-cp-1.18.0.jar\",\n          \"cs-base-cp-1.4.0.jar\",\n          \"cs-tesseract-ocr-cp-1.0.1.jar\"\n        ]\n      },\n      {\n        \"user\": \"sfdev\",\n        \"github_repo\": \"pe-pan/rpa-salesforce\",\n        \"update_binaries\": \"yes\",\n        \"cp_files\": [\n          \"oo10-base-cp-1.18.0.jar\",\n          \"cs-base-cp-1.4.0.jar\",\n          \"cs-tesseract-ocr-cp-1.0.1.jar\",\n          \"cs-microsoft-office365-cp-1.0.0.jar\",\n          \"oo-microsoft-office-365-cp-2.2.2.jar\",\n          \"oo-demos-cp-1.0.0.jar\"\n        ]\n      },\n      {\n        \"user\": \"rpadev\",\n        \"github_repo\": \"rpa-micro-focus/rpa-rpa\",\n        \"update_binaries\": \"no\",\n        \"cp_files\": [\n          \"cs-base-cp-1.4.0.jar\"\n        ]\n      },\n      {\n        \"user\": \"sapdev\",\n        \"github_repo\": \"pe-pan/rpa-sap\",\n        \"update_binaries\": \"yes\",\n        \"cp_files\": [\n          \"cs-base-cp-1.4.0.jar\"\n        ]\n      }\n    ]\n}\n'''}"
    - users_password:
        required: false
        sensitive: true
    - org_name:
        required: false
    - group_name:
        default: ADMINISTRATOR
        required: true
    - repre_prefix:
        default: OO_AGR_
        required: true
    - reset_user:
        default: 'false'
        required: true
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_organization_id
    - get_organization_id:
        do:
          io.cloudslang.microfocus.rpa.idm.organization.get_organization_id:
            - token: '${token}'
            - org_name: "${get('org_name', get_sp('io.cloudslang.microfocus.rpa.idm_tenant'))}"
        publish:
          - org_id
        navigate:
          - SUCCESS: get_group_id
          - FAILURE: on_failure
    - create_demo_user:
        loop:
          for: "user_json in eval(users_json)['users']"
          do:
            io.cloudslang.microfocus.rpa.demo.sub_flows.create_demo_user:
              - token: '${token}'
              - ws_user: "${user_json['user']}"
              - ws_password:
                  value: "${get('users_password', get_sp('io.cloudslang.microfocus.rpa.rpa_password'))}"
                  sensitive: true
              - ws_tenant: "${get('org_name', get_sp('io.cloudslang.microfocus.rpa.idm_tenant'))}"
              - org_id: '${org_id}'
              - group_id: '${group_id}'
              - repre_name: '${repre_prefix+group_name}'
              - idm_groups: '${idm_groups}'
              - github_repo: "${user_json['github_repo']}"
              - update_binaries: "${user_json['update_binaries']}"
              - cp_folder: "${eval(users_json)['cp_folder']}"
              - cp_files: "${str([eval(users_json)['cp_folder']+'\\\\'+cp_file for cp_file in user_json['cp_files']])}"
              - reset_user: '${reset_user}'
          break:
            - FAILURE
          publish:
            - cp_status_json
            - repo_status_json
            - failure
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - INCOMPLETE: SUCCESS
    - get_group_id:
        do:
          io.cloudslang.microfocus.rpa.idm.group.get_group_id:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_name: '${group_name}'
        publish:
          - group_id
        navigate:
          - SUCCESS: create_demo_user
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 93
        'y': 110
      get_organization_id:
        x: 90
        'y': 288
      create_demo_user:
        x: 258
        'y': 290
        navigate:
          48980fb1-f643-ade4-1051-3cef7502aa0a:
            targetId: 6521bba1-f326-c31a-7947-f2ff157436cf
            port: SUCCESS
          508f2bfe-7942-d4a6-f355-05eb0f008525:
            targetId: 6521bba1-f326-c31a-7947-f2ff157436cf
            port: INCOMPLETE
      get_group_id:
        x: 264
        'y': 121
    results:
      SUCCESS:
        6521bba1-f326-c31a-7947-f2ff157436cf:
          x: 427
          'y': 127
