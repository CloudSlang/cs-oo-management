namespace: io.cloudslang.microfocus.rpa.ssx.scenario.test
flow:
  name: test_get_scenarios
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_scenarios
    - get_scenarios:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.get_scenarios:
            - token: '${token}'
        publish:
          - scenarios_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_scenarios:
        x: 234
        'y': 95
        navigate:
          777596ba-b437-3415-df98-9503f51da2b0:
            targetId: b0379c12-98e3-048b-c6cc-0d4a8324f1a8
            port: SUCCESS
      get_token:
        x: 58
        'y': 96
    results:
      SUCCESS:
        b0379c12-98e3-048b-c6cc-0d4a8324f1a8:
          x: 401
          'y': 85
