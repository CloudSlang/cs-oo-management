########################################################################################################################
#!!
#! @description: Receives ID and other properties of the SCM repository (of index 0; one SCM per one Workspace). The results will be empty if no repository exists yet.
#!
#! @input ws_id: Workspace ID
#! @input repo_index: Which repository in Workspace to take
#!
#! @output repo_id: SCM repository ID; empty if no repository exists yet
#! @output scm_url: SCM repository URL
#! @output repo_owner: SCM repository owner (penultimate part of SCM URL)
#! @output repo_name: SCM repository name (trailing part of SCM URL)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.designer.repository
flow:
  name: get_repo_details
  inputs:
    - ws_id
    - repo_index:
        default: '0'
        private: true
  workflow:
    - get_repos:
        do:
          io.cloudslang.microfocus.oo.designer.repository.get_repos:
            - ws_id: '${ws_id}'
            - repo_index: '${repo_index}'
        publish:
          - repos_json
          - repo_pton: "${'' if repos_json == '[]' else str(eval(repos_json.replace(\":null\",\":None\").replace(\":true\",\":True\").replace(\":false\",\":False\"))[int(repo_index)])}"
          - repo_id: "${'' if repo_pton == '' else eval(repo_pton)['id']}"
          - scm_url: "${'' if repo_pton == '' else eval(repo_pton)['scmURL']}"
          - repo_owner: "${'' if repo_pton == '' else eval(repo_pton)['username']}"
          - repo_name: "${'' if repo_pton == '' else eval(repo_pton)['repositoryName']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - repo_id: '${repo_id}'
    - scm_url: '${scm_url}'
    - repo_owner: '${repo_owner}'
    - repo_name: '${repo_name}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_repos:
        x: 78
        'y': 112
        navigate:
          62189987-a795-468b-f699-8c5137552d77:
            targetId: 85d1b658-7041-150a-8f47-cbf069af59e4
            port: SUCCESS
    results:
      SUCCESS:
        85d1b658-7041-150a-8f47-cbf069af59e4:
          x: 321
          'y': 114
