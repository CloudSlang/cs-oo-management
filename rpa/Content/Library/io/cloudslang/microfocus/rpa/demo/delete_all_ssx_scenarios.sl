namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: delete_all_ssx_scenarios
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
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${scenarios_json}'
            - json_path: '$.items.*.id'
        publish:
          - scenario_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: delete_scenario
          - FAILURE: on_failure
    - delete_scenario:
        loop:
          for: id in scenario_ids
          do:
            io.cloudslang.microfocus.rpa.ssx.scenario.delete_scenario:
              - token: '${token}'
              - id: '${id}'
          break:
            - FAILURE
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
        x: 201
        'y': 117
      json_path_query:
        x: 357
        'y': 123
      get_token:
        x: 44
        'y': 118
      delete_scenario:
        x: 518
        'y': 126
        navigate:
          7b748339-f707-f8cf-42bb-ef82448ab827:
            targetId: 2f8866bb-a2b3-0c58-b8de-0c280c83c36f
            port: SUCCESS
    results:
      SUCCESS:
        2f8866bb-a2b3-0c58-b8de-0c280c83c36f:
          x: 669
          'y': 137
