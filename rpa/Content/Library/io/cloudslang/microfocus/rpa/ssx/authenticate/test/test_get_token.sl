namespace: io.cloudslang.microfocus.rpa.ssx.authenticate.test
flow:
  name: test_get_token
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_true
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(token.find('-', 8, 9) == 8 and token.find('-', 13, 14) == 13 and token.find('-', 18, 19) == 18 and token.find('-', 23, 24) == 23)}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_true:
        x: 315
        'y': 139
        navigate:
          523a5d76-0e1f-7b99-72e3-8e25e3b0470d:
            targetId: 773b302b-3660-eed6-8c80-e14404599495
            port: 'TRUE'
          9920d46a-46b8-fba0-1478-d76cffb59e10:
            targetId: ccf6b953-2526-3fbd-9224-1389b40288fb
            port: 'FALSE'
      get_token:
        x: 80
        'y': 153
    results:
      FAILURE:
        ccf6b953-2526-3fbd-9224-1389b40288fb:
          x: 315
          'y': 336
      SUCCESS:
        773b302b-3660-eed6-8c80-e14404599495:
          x: 493
          'y': 139
