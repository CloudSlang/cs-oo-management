########################################################################################################################
#!!
#! @description: Adds an SSX scenario.
#!
#! @input category_id: Under which category to add the scenario
#! @input scenario_json: JSON doc fully describing the scenario (including all flow inputs). On category ID, %s needs to be placed.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.scenario
flow:
  name: add_scenario
  inputs:
    - token
    - category_id
    - scenario_json
  workflow:
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: /rest/v0/scenarios
            - token: '${token}'
            - method: POST
            - body: '${scenario_json % category_id}'
        publish:
          - scenario_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${scenario_json}'
            - json_path: $.id
        publish:
          - id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - id: '${id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssx_http_action:
        x: 77
        'y': 129
      json_path_query:
        x: 232
        'y': 128
        navigate:
          703043ee-eb1c-de8f-096c-51bde07ef1ce:
            targetId: 95dfb3ec-a5cd-6574-d06a-da1e85b158de
            port: SUCCESS
    results:
      SUCCESS:
        95dfb3ec-a5cd-6574-d06a-da1e85b158de:
          x: 394
          'y': 137
