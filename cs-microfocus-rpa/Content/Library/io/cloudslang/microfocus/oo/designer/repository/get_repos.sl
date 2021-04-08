########################################################################################################################
#!!
#! @description: Receives all SCM repositories in the given workspace.
#!
#! @input ws_id: Workspace ID
#!
#! @output repos_json: JSON document with all SCM repositories
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.designer.repository
flow:
  name: get_repos
  inputs:
    - ws_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.oo.designer._operations.designer_http_action:
            - url: "${'/rest/v0/workspaces/%s/repositories' % ws_id}"
            - method: GET
            - verify_result: list
        publish:
          - repos_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - repos_json: '${repos_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 69
        'y': 114
        navigate:
          bef2fa59-d2db-9bff-5df2-a66aa8e073c4:
            targetId: 9c7ce730-cf44-f82d-ed81-768f2be3db50
            port: SUCCESS
    results:
      SUCCESS:
        9c7ce730-cf44-f82d-ed81-768f2be3db50:
          x: 252
          'y': 115
