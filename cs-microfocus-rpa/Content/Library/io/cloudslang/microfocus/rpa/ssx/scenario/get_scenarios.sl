########################################################################################################################
#!!
#! @description: Gets all SSX scenarios.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.scenario
flow:
  name: get_scenarios
  inputs:
    - token
  workflow:
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: /rest/v0/scenarios/query
            - token: '${token}'
            - method: POST
            - body: '{"context":"SCENARIOS_MANAGEMENT"}'
        publish:
          - scenarios_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - scenarios_json: '${scenarios_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssx_http_action:
        x: 77
        'y': 128
        navigate:
          5504f32d-f9f0-0b05-6293-fed3e774a169:
            targetId: 95dfb3ec-a5cd-6574-d06a-da1e85b158de
            port: SUCCESS
    results:
      SUCCESS:
        95dfb3ec-a5cd-6574-d06a-da1e85b158de:
          x: 241
          'y': 138
