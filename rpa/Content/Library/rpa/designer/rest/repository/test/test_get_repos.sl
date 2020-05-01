namespace: rpa.designer.rest.repository.test
flow:
  name: test_get_repos
  workflow:
    - get_token:
        do:
          rpa.designer.rest.authenticate.get_token: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - get_repos:
        do:
          rpa.designer.rest.repository.get_repos:
            - ws_id: '${ws_id}'
        publish:
          - repos_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_default_ws_id:
        do:
          rpa.designer.rest.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_repos
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 80
        'y': 42
      get_repos:
        x: 407
        'y': 48
        navigate:
          11bca066-5b3b-1b0a-5593-10e663ae9a4c:
            targetId: cb00cdab-90e6-fb0b-9cb8-05223e5dd6e3
            port: SUCCESS
      get_default_ws_id:
        x: 221
        'y': 43
    results:
      SUCCESS:
        cb00cdab-90e6-fb0b-9cb8-05223e5dd6e3:
          x: 575
          'y': 42
