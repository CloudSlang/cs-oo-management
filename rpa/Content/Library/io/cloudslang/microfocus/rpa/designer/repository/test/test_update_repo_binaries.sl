namespace: io.cloudslang.microfocus.rpa.designer.repository.test
flow:
  name: test_update_repo_binaries
  inputs:
    - ws_user: sfdev
    - cp_folder: "c:\\\\temp"
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${ws_user}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - get_default_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_repo_details
    - update_repo_binaries:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.update_repo_binaries:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - github_repo: '${repo_owner+"/"+repo_name}'
            - cp_folder: '${cp_folder}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
          - NO_BINARIES: FAILURE
    - get_repo_details:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.get_repo_details:
            - ws_id: '${ws_id}'
        publish:
          - scm_url
          - repo_owner: '${scm_url.split("/")[-2]}'
          - repo_name: "${scm_url.split(\"/\")[-1][0:-4] if scm_url.endswith('.git') else scm_url.split(\"/\")[-1]}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_repo_binaries
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
      get_repo_details:
        x: 427
        'y': 101
      update_repo_binaries:
        x: 604
        'y': 100
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
          x: 604
          'y': 281
