########################################################################################################################
#!!
#! @description: Adds or updates an SSX scenario.
#!
#! @input category_id: Under which category to add the scenario
#! @input scenario_json: JSON doc fully describing the scenario (including all flow inputs). On category ID, %s needs to be placed.
#! @input existing_scenarios_json: List of existing scenarios (for update)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.sub_flows
flow:
  name: add_or_update_scenario
  inputs:
    - token
    - category_id
    - scenario_json
    - existing_scenarios_json
  workflow:
    - get_scenario_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${scenario_json}'
            - json_path: $.name
        publish:
          - scenario_name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_scenario_id
          - FAILURE: on_failure
    - add_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.add_scenario:
            - token: '${token}'
            - category_id: '${category_id}'
            - scenario_json: '${deprocessed_scenario_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - update_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.update_scenario:
            - token: '${token}'
            - id: '${scenario_id}'
            - category_id: '${category_id}'
            - scenario_json: '${deprocessed_scenario_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_scenario_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${existing_scenarios_json}'
            - json_path: "${\"$.items[?(@.name == '%s')].id\" % scenario_name}"
            - scenario_json: '${scenario_json}'
        publish:
          - scenario_id: '${return_result[1:-1]}'
          - deprocessed_scenario_json: "${scenario_json.replace(\"'__NULL__'\", \"null\").replace(\"'__TRUE__'\", \"true\").replace(\"'__FALSE__'\", \"false\").replace(\"'%s'\",\"%s\").replace(\"': True\", \"': true\").replace(\"': False\", \"': false\").replace(\"'\", '\"').replace(\"__QUOTE__\",\"'\")}"
        navigate:
          - SUCCESS: scenario_exists
          - FAILURE: add_scenario
    - scenario_exists:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(scenario_id) > 0)}'
        navigate:
          - 'TRUE': update_scenario
          - 'FALSE': add_scenario
  outputs:
    - id: '${id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      add_scenario:
        x: 212
        'y': 146
        navigate:
          592cc9d4-ee39-7417-3181-c00079bd5584:
            targetId: 95dfb3ec-a5cd-6574-d06a-da1e85b158de
            port: SUCCESS
      update_scenario:
        x: 395
        'y': 361
        navigate:
          e877669a-5b0b-3174-01d3-fc4ab422656a:
            targetId: 95dfb3ec-a5cd-6574-d06a-da1e85b158de
            port: SUCCESS
      get_scenario_name:
        x: 44
        'y': 159
      get_scenario_id:
        x: 43
        'y': 370
      scenario_exists:
        x: 213
        'y': 367
    results:
      SUCCESS:
        95dfb3ec-a5cd-6574-d06a-da1e85b158de:
          x: 394
          'y': 137
