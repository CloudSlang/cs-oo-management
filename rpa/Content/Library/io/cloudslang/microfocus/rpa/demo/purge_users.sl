########################################################################################################################
#!!
#! @description: Removes the given user workspace (in Designer) and then also the user itself from IDM
#!
#! @input usernames: List of users to be purged
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: purge_users
  inputs:
    - usernames: 'aosdev11, aosdev12, aosdev2, msgraphdev11, msgraphdev12, msgraphdev2, robosocdev11, robosocdev12, robosocdev2, rpadev11, rpadev12, rpadev2, salesforcedev11, salesforcedev12, salesforcedev2, sapdev11, sapdev12, sapdev2'
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${usernames}'
        publish:
          - username: '${result_string.strip()}'
        navigate:
          - HAS_MORE: get_user_token
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_user_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${username}'
        publish:
          - token
        navigate:
          - FAILURE: logout_user
          - SUCCESS: get_default_ws_id
    - get_default_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: logout_user
          - SUCCESS: is_workspace
    - delete_workspace:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.delete_workspace:
            - token: '${token}'
            - ws_id: '${ws_id}'
        navigate:
          - FAILURE: logout_user
          - SUCCESS: logout_user
    - delete_user:
        do:
          io.cloudslang.microfocus.rpa.idm.user.delete_user:
            - token: '${idm_token}'
            - username_or_id: '${username}'
            - org_id: '${org_id}'
        navigate:
          - FAILURE: logout_admin
          - SUCCESS: logout_admin
    - get_organization_id:
        do:
          io.cloudslang.microfocus.rpa.idm.organization.get_organization_id:
            - token: '${idm_token}'
        publish:
          - org_id
        navigate:
          - SUCCESS: delete_user
          - FAILURE: logout_admin
    - logout_user:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.logout: []
        navigate:
          - SUCCESS: get_admin_token
    - is_workspace:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(ws_id) > 0)}'
        navigate:
          - 'TRUE': delete_workspace
          - 'FALSE': logout_user
    - get_admin_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - idm_token: '${token}'
        navigate:
          - FAILURE: logout_admin
          - SUCCESS: get_organization_id
    - logout_admin:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.logout: []
        navigate:
          - SUCCESS: list_iterator
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      logout_user:
        x: 531
        'y': 416
      get_admin_token:
        x: 299
        'y': 417
      is_workspace:
        x: 954
        'y': 238
      delete_workspace:
        x: 954
        'y': 414
      get_user_token:
        x: 709
        'y': 67
      list_iterator:
        x: 515
        'y': 70
        navigate:
          3b8e89c5-a18d-726a-51f4-5433099ccd6f:
            targetId: 66d13bdc-c124-cad2-f0b7-928b14bf78f7
            port: NO_MORE
      get_default_ws_id:
        x: 956
        'y': 67
      logout_admin:
        x: 295
        'y': 70
      get_organization_id:
        x: 68
        'y': 416
      delete_user:
        x: 68
        'y': 80
    results:
      SUCCESS:
        66d13bdc-c124-cad2-f0b7-928b14bf78f7:
          x: 414
          'y': 229
