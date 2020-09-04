########################################################################################################################
#!!
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.user
flow:
  name: delete_user
  inputs:
    - token
    - username_or_id
    - org_id
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/users/%s' % (org_id, username_or_id)}"
            - token: '${token}'
            - method: DELETE
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_from_db
    - delete_from_db:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/dbusers/%s' % (org_id, username_or_id)}"
            - token: '${token}'
            - method: DELETE
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 76
        'y': 110
      delete_from_db:
        x: 243
        'y': 117
        navigate:
          568c2917-6c33-7f60-772b-b26a6688877f:
            targetId: 68e54ed6-56e7-623e-0cd4-b8f49793294d
            port: SUCCESS
    results:
      SUCCESS:
        68e54ed6-56e7-623e-0cd4-b8f49793294d:
          x: 411
          'y': 120
