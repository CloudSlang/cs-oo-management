########################################################################################################################
#!!
#! @description: Retrieves the user details or fails if it does not exist.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.user
flow:
  name: get_user
  inputs:
    - token
    - username_or_id
    - org_id
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/users/%s?includePerms=false' % (org_id, username_or_id)}"
            - token: '${token}'
            - method: GET
        publish:
          - user_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - user_json: '${user_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 61
        'y': 90
        navigate:
          1016836c-43b1-83ef-749c-4ebae10b0897:
            targetId: 68e54ed6-56e7-623e-0cd4-b8f49793294d
            port: SUCCESS
    results:
      SUCCESS:
        68e54ed6-56e7-623e-0cd4-b8f49793294d:
          x: 227
          'y': 97
