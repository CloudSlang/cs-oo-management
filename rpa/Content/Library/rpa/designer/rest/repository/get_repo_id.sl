########################################################################################################################
#!!
#! @description: Retrieves ID of the SCM repository
#!
#! @input ws_id: Workspace ID
#! @input scm_url: Repository URL
#!!#
########################################################################################################################
namespace: rpa.designer.rest.repository
flow:
  name: get_repo_id
  inputs:
    - ws_id
    - scm_url
  workflow:
    - get_repos:
        do:
          rpa.designer.rest.repository.get_repos:
            - ws_id: '${ws_id}'
        publish:
          - repos_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${repos_json}'
            - json_path: "${\"$[?(@.scmURL == '%s')].id\" % scm_url}"
        publish:
          - repo_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - repo_id: '${repo_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_repos:
        x: 78
        'y': 112
      json_path_query:
        x: 241
        'y': 118
        navigate:
          88b92cc1-72ba-4d93-0b3c-027b0eeed792:
            targetId: 85d1b658-7041-150a-8f47-cbf069af59e4
            port: SUCCESS
    results:
      SUCCESS:
        85d1b658-7041-150a-8f47-cbf069af59e4:
          x: 403
          'y': 116
