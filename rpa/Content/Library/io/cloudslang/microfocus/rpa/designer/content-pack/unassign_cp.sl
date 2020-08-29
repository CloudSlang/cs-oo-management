########################################################################################################################
#!!
#! @description: Unassigns CP from workspace (does not remove from Designer)
#!
#! @input ws_id: Workspace ID
#! @input cp_id: CP ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack
flow:
  name: unassign_cp
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
            - method: DELETE
        publish:
          - cp_status_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - cp_status_json: '${cp_status_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 66
        'y': 127
        navigate:
          0e11deb1-d0a6-1219-16b2-04dfbc17028f:
            targetId: 07a90d5e-4ee8-1467-a00a-713dee9d461b
            port: SUCCESS
    results:
      SUCCESS:
        07a90d5e-4ee8-1467-a00a-713dee9d461b:
          x: 246
          'y': 126
