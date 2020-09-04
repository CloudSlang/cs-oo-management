########################################################################################################################
#!!
#! @description: Deletes the given SCM repository
#!
#! @input ws_id: Workspace ID
#! @input repo_id: Repository ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.repository
flow:
  name: delete_repo
  inputs:
    - token
    - ws_id
    - repo_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/workspaces/%s/repositories/%s' % (ws_id, repo_id)}"
            - token: '${token}'
            - method: DELETE
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
        x: 49
        'y': 100
        navigate:
          fe77bd37-260b-fc58-19a3-42af61f076c7:
            targetId: 94b4fc08-0ebd-7e98-08da-4faa0dc167d0
            port: SUCCESS
    results:
      SUCCESS:
        94b4fc08-0ebd-7e98-08da-4faa0dc167d0:
          x: 226
          'y': 104
