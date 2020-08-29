########################################################################################################################
#!!
#! @description: Retrieves all workspaces
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.workspace
flow:
  name: get_workspaces
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: /rest/v0/workspaces
            - method: GET
            - verify_result: list
        publish:
          - workspaces_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - workspaces_json: '${workspaces_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 88
        'y': 117
        navigate:
          c09be4a3-5739-e330-5b82-6ae6db351db8:
            targetId: ebb84087-7827-90a8-a559-5a9ec89f4e53
            port: SUCCESS
    results:
      SUCCESS:
        ebb84087-7827-90a8-a559-5a9ec89f4e53:
          x: 275
          'y': 122
