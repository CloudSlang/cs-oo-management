namespace: io.cloudslang.microfocus.rpa.designer.content-pack.test
flow:
  name: test_get_cps
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_cp_id
    - get_cp_id:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.get_cp_id:
            - cp_name: Base
            - cp_version: 1.17.1
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 81
        'y': 84
      get_cp_id:
        x: 239
        'y': 91
        navigate:
          a7b8f5f1-ec3b-39a5-2ec9-70e3d8bc1e34:
            targetId: 9a051bd7-ab6b-f5dc-dce9-cbea71a3ed7c
            port: SUCCESS
    results:
      SUCCESS:
        9a051bd7-ab6b-f5dc-dce9-cbea71a3ed7c:
          x: 409
          'y': 93
