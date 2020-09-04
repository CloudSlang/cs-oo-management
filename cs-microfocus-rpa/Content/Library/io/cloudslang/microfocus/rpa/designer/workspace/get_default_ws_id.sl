########################################################################################################################
#!!
#! @description: Retrieves default workspace ID.
#!
#! @output ws_id: Workspace ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.workspace
flow:
  name: get_default_ws_id
  workflow:
    - get_workspaces:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_workspaces: []
        publish:
          - workspaces_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${workspaces_json}'
            - json_path: '$[?(@.name == "Default_Workspace")].id'
        publish:
          - ws_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ws_id: '${ws_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_workspaces:
        x: 114
        'y': 75
      json_path_query:
        x: 293
        'y': 75
        navigate:
          8bb6a7e7-40a0-06b6-1148-8d2a0fd71fc1:
            targetId: dda6cb51-b6e3-203a-1c55-63d49cf2f730
            port: SUCCESS
    results:
      SUCCESS:
        dda6cb51-b6e3-203a-1c55-63d49cf2f730:
          x: 464
          'y': 73
