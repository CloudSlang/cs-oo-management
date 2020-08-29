########################################################################################################################
#!!
#! @description: Resets user's password. User will have to change it upon the next login.
#!
#! @input username: User to be updated.
#! @input password: Password of the user.
#! @input org_id: Under which organization should be the user updated.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.user
flow:
  name: reset_password
  inputs:
    - token
    - username
    - password
    - org_id
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/dbusers/%s/resetpassword' % (org_id, username)}"
            - token: '${token}'
            - method: PATCH
            - body: "${'{\"password\":\"%s\"}' % password}"
        publish:
          - password_json: '${return_result}'
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - password_json: password_json
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 83
        'y': 130
        navigate:
          4818e733-5152-4326-b811-a225f0a9dd9f:
            targetId: 830d3d5a-c217-a98b-b874-9ca722df512f
            port: SUCCESS
    results:
      SUCCESS:
        830d3d5a-c217-a98b-b874-9ca722df512f:
          x: 253
          'y': 132
