########################################################################################################################
#!!
#! @description: Adds a user to the IDM service.
#!
#! @input username: User to be added.
#! @input password: Password of the user.
#! @input org_id: Under which organization should be the user added.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.user
flow:
  name: add_user
  inputs:
    - token
    - username
    - password
    - org_id
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/dbusers' % org_id}"
            - token: '${token}'
            - method: POST
            - body: "${'{\"name\":\"%s\",\"displayName\":\"%s\",\"metadata\":{},\"password\":\"%s\",\"type\":\"SEEDED_USER\"}' % (username, username, password)}"
        publish:
          - user_json: '${return_result}'
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - user_json: '${user_json}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 91
        'y': 139
        navigate:
          47025878-684f-aaec-6ff9-f15ef528238b:
            targetId: 830d3d5a-c217-a98b-b874-9ca722df512f
            port: SUCCESS
    results:
      SUCCESS:
        830d3d5a-c217-a98b-b874-9ca722df512f:
          x: 273
          'y': 129
