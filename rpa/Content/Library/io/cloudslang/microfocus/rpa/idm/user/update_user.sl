########################################################################################################################
#!!
#! @description: Updates an existing user in the IDM service.
#!
#! @input username: User to be updated.
#! @input org_id: Under which organization should be the user updated.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.user
flow:
  name: update_user
  inputs:
    - token
    - username
    - org_id
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/dbusers/%s' % (org_id, username)}"
            - token: '${token}'
            - method: PUT
            - body: "${'{\"name\":\"%s\",\"displayName\":\"%s\",\"metadata\":{},\"type\":\"SEEDED_USER\"}' % (username, username)}"
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
          3b05123f-cdda-d776-164d-bcb6bbe0cfd8:
            targetId: 830d3d5a-c217-a98b-b874-9ca722df512f
            port: SUCCESS
    results:
      SUCCESS:
        830d3d5a-c217-a98b-b874-9ca722df512f:
          x: 258
          'y': 144
