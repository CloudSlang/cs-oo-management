namespace: io.cloudslang.microfocus.rpa.designer.repository.test
flow:
  name: test_update_repo
  inputs:
    - usernames:
        default: 'aosdev,sfdev,sapdev,admin'
        required: true
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${usernames}'
        publish:
          - username: '${result_string}'
        navigate:
          - HAS_MORE: get_token
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${username}'
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
          - SUCCESS: get_first_repo_id
    - get_first_repo_id:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.get_repos:
            - ws_id: '${ws_id}'
        publish:
          - repos_json
          - repo_id: "${eval(repos_json.replace(\":null\",\":None\"))[0]['id']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_repo
    - update_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.update_repo:
            - token: '${token}'
            - repo_id: '${repo_id}'
        publish:
          - process_json
          - process_id
          - status_json
          - process_status
        navigate:
          - FAILURE: on_failure
          - SUCCESS: logout
    - logout:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.logout: []
        publish: []
        navigate:
          - SUCCESS: list_iterator
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      logout:
        x: 99
        'y': 238
      list_iterator:
        x: 334
        'y': 87
        navigate:
          95a6b5c6-ed43-92b1-2e91-07d54c3ca363:
            targetId: 835a9716-858e-6ebd-f987-90a631663b7a
            port: NO_MORE
      get_token:
        x: 550
        'y': 239
      get_default_ws_id:
        x: 549
        'y': 430
      get_first_repo_id:
        x: 336
        'y': 509
      update_repo:
        x: 98
        'y': 425
    results:
      SUCCESS:
        835a9716-858e-6ebd-f987-90a631663b7a:
          x: 546
          'y': 86
