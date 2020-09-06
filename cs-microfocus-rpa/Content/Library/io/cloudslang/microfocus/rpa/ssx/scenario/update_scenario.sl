########################################################################################################################
#!!
#! @description: Updates an existing SSX scenario.
#!
#! @input scenario_id: ID of a scenario to be updated
#! @input category_id: Under which category to place the scenario
#! @input scenario_json: JSON document describing the scenario (including all flow inputs). Don't add categoryId property; it will be added to the JSON document.
#!
#! @output updated_scenario_json: JSON document describing the updated scenario
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.scenario
flow:
  name: update_scenario
  inputs:
    - token
    - scenario_id
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
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: "${'/rest/v0/scenarios/%s' % scenario_id}"
            - token: '${token}'
            - method: PUT
            - body: '${scenario_json}'
        publish:
          - updated_scenario_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - updated_scenario_json: '${updated_scenario_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_value:
        x: 37
        'y': 71
      ssx_http_action:
        x: 211
        'y': 71
        navigate:
          51b1b8e2-5c44-e317-28fe-06eb996abbea:
            targetId: 95dfb3ec-a5cd-6574-d06a-da1e85b158de
            port: SUCCESS
    results:
      SUCCESS:
        95dfb3ec-a5cd-6574-d06a-da1e85b158de:
          x: 388
          'y': 73
