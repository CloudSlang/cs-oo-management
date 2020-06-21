namespace: rpa.designer.rest.repository.test
flow:
  name: test_update_repo_binaries
  inputs:
    - ws_user: ray
    - cp_folder: "c:\\\\temp"
  workflow:
    - get_token:
        do:
          rpa.designer.rest.authenticate.get_token:
            - ws_user: '${ws_user}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - get_default_ws_id:
        do:
          rpa.designer.rest.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_scm_url
    - get_scm_url:
        do:
          rpa.designer.rest.repository.get_repos:
            - ws_id: '${ws_id}'
        publish:
          - repos_json
          - scm_url: "${'' if repos_json == '[]' else eval(repos_json.replace(\":null\",\":None\"))[0]['scmURL']}"
          - repo_owner: "${'' if repos_json == '[]' else eval(repos_json.replace(\":null\",\":None\"))[0]['username']}"
          - repo_name: "${'' if repos_json == '[]' else eval(repos_json.replace(\":null\",\":None\"))[0]['repositoryName']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_repo_binaries
    - update_repo_binaries:
        do:
          rpa.designer.rest.repository.update_repo_binaries:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - github_repo: '${repo_owner+"/"+repo_name}'
            - cp_folder: '${cp_folder}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
          - NO_BINARIES: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 65
        'y': 98
      get_default_ws_id:
        x: 250
        'y': 97
      get_scm_url:
        x: 446
        'y': 110
      update_repo_binaries:
        x: 603
        'y': 95
        navigate:
          e4d8171f-7d63-4f57-590c-c3f7114beca2:
            targetId: aab3d95c-b82a-1c25-a4df-f4f5dcd35a3a
            port: SUCCESS
          aae2ad0f-40ed-3334-c334-b92e8425fd83:
            targetId: 2d2e5d09-e1af-9f6d-8b27-d538614baaff
            port: NO_BINARIES
    results:
      SUCCESS:
        aab3d95c-b82a-1c25-a4df-f4f5dcd35a3a:
          x: 792
          'y': 99
      FAILURE:
        2d2e5d09-e1af-9f6d-8b27-d538614baaff:
          x: 591
          'y': 258
