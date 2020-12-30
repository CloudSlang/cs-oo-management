########################################################################################################################
#!!
#! @description: Retrieves a JSON document describing all the projects in the workspace.
#!
#! @input ws_id: Workspace ID
#!
#! @output projects_json: JSON document describing the project details
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.project
flow:
  name: get_projects
  inputs:
    - ws_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/workspaces/%s/projects' % ws_id}"
            - method: GET
        publish:
          - projects_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - projects_json: '${projects_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 59
        'y': 102
        navigate:
          6a91cf3f-f5b8-8225-54e1-263a89662919:
            targetId: 68f5f39f-c2da-9081-5dc5-b256de41ffa9
            port: SUCCESS
    results:
      SUCCESS:
        68f5f39f-c2da-9081-5dc5-b256de41ffa9:
          x: 239
          'y': 107
