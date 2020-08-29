namespace: io.cloudslang.microfocus.rpa.designer.workspace.test
flow:
  name: test_get_default_ws_id
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token: []
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
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_default_ws_id:
        x: 267
        'y': 69
        navigate:
          87ca286d-9717-4491-e74a-51c921ed3811:
            targetId: ed7edf26-ab98-2add-7bbd-04eae01e6aac
            port: SUCCESS
      get_token:
        x: 68
        'y': 71
    results:
      SUCCESS:
        ed7edf26-ab98-2add-7bbd-04eae01e6aac:
          x: 440
          'y': 61
