namespace: rpa.designer.rest.dependency.test
flow:
  name: test_import_cp
  inputs:
    - cp_file
  workflow:
    - get_token:
        do:
          rpa.designer.rest.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_cp
    - import_cp:
        do:
          rpa.designer.rest.dependency.import_cp:
            - token: '${token}'
            - cp_file: '${cp_file}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - ALREADY_IMPORTED: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 96
        'y': 88
      import_cp:
        x: 265
        'y': 84
        navigate:
          0d1cd0cd-d1cd-12f7-ed41-2cd6946b08d1:
            targetId: d844c66b-29f0-8ce6-598e-39aa803eb462
            port: SUCCESS
          fea1f26c-5c56-543c-a895-c22ba18b8395:
            targetId: d844c66b-29f0-8ce6-598e-39aa803eb462
            port: ALREADY_IMPORTED
    results:
      SUCCESS:
        d844c66b-29f0-8ce6-598e-39aa803eb462:
          x: 423
          'y': 77
