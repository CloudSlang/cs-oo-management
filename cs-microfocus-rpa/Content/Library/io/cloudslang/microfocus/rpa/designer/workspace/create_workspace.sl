########################################################################################################################
#!!
#! @description: Creates user's Workspace
#!
#! @input ws_name: Workspace name; now, only Default_Workspace is supoported
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.workspace
flow:
  name: create_workspace
  inputs:
    - token
    - ws_name: Default_Workspace
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: /rest/v0/workspaces
            - token: '${token}'
            - method: POST
            - body: '${ws_name}'
        publish:
          - ws_json: '${return_result}'
          - ws_id: "${eval(return_result)['id']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - ws_json: '${ws_json}'
    - ws_id: '${ws_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 78
        'y': 121
        navigate:
          5c9766d1-6695-61b6-3f1a-76e2b521964e:
            targetId: b123b2be-c40b-c7bf-e9a4-38b346056431
            port: SUCCESS
    results:
      SUCCESS:
        b123b2be-c40b-c7bf-e9a4-38b346056431:
          x: 264
          'y': 116
