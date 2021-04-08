########################################################################################################################
#!!
#! @description: Creates an SSX scenario.
#!
#! @input category_id: Under which category to create the scenario
#! @input scenario_json: JSON document describing the scenario (including all flow inputs). Don't add categoryId property; it will be added to the JSON document.
#!
#! @output scenario_id: ID of the created scenario
#! @output added_scenario_json: JSON document describing the added scenario
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.ssx.scenario
flow:
  name: add_scenario
  inputs:
    - token
    - category_id
    - scenario_json
  workflow:
    - add_value:
        do:
          io.cloudslang.base.json.add_value:
            - json_input: '${scenario_json}'
            - json_path: categoryId
            - value: '${category_id}'
        publish:
          - scenario_json: '${return_result}'
        navigate:
          - SUCCESS: ssx_http_action
          - FAILURE: on_failure
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.oo.ssx._operations.ssx_http_action:
            - url: /rest/v0/scenarios
            - token: '${token}'
            - method: POST
            - body: '${scenario_json}'
        publish:
          - added_scenario_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${added_scenario_json}'
            - json_path: $.id
        publish:
          - scenario_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - scenario_id: '${scenario_id}'
    - added_scenario_json: '${added_scenario_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_value:
        x: 39
        'y': 73
      ssx_http_action:
        x: 212
        'y': 72
      json_path_query:
        x: 387
        'y': 71
        navigate:
          703043ee-eb1c-de8f-096c-51bde07ef1ce:
            targetId: 95dfb3ec-a5cd-6574-d06a-da1e85b158de
            port: SUCCESS
    results:
      SUCCESS:
        95dfb3ec-a5cd-6574-d06a-da1e85b158de:
          x: 557
          'y': 72
