########################################################################################################################
#!!
#! @description: Deletes the workspace
#!
#! @input ws_id: Workspace ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.workspace
flow:
  name: delete_workspace
  inputs:
    - token
    - ws_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/workspaces/%s' % ws_id}"
            - token: '${token}'
            - method: DELETE
            - verify_result: nothing
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
