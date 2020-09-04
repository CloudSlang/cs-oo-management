########################################################################################################################
#!!
#! @description: Assigns the given content pack to the given workspace
#!
#! @input ws_id: Workspace ID
#! @input cp_id: Content Pack ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack
flow:
  name: assign_cp
  inputs:
    - token
    - ws_id
    - cp_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/workspaces/%s/dependencies/%s' % (ws_id, cp_id)}"
            - token: '${token}'
            - method: PUT
        publish:
          - status_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - status_json: '${status_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 109
        'y': 105
        navigate:
          24ea7c99-af6c-7f02-5f30-88f5d92e440d:
            targetId: 5336fe52-b5dc-bd54-269d-ee8857a86c5f
            port: SUCCESS
    results:
      SUCCESS:
        5336fe52-b5dc-bd54-269d-ee8857a86c5f:
          x: 277
          'y': 101
