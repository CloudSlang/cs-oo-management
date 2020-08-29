########################################################################################################################
#!!
#! @input category_json: Values of the single category to create/update
#! @input scenarios_json: List of scenarios to be added/updated under the category
#! @input existing_categories_json: List of existing categories (for update)
#! @input existing_scenarios_json: List of existing scenarios (for update)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.sub_flows
flow:
  name: update_category_scenarios
  inputs:
    - token
    - category_json
    - scenarios_json
    - existing_categories_json:
        required: true
    - existing_scenarios_json:
        required: true
  workflow:
    - get_category_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: $.name
        publish:
          - category_name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_category_id
          - FAILURE: on_failure
    - add_category:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.add_category:
            - token: '${token}'
            - category_json: "${str(category_json).replace(\"'__NULL__'\", \"null\").replace(\"'\", '\"')}"
        publish:
          - category_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: contains_scenarios
    - contains_scenarios:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(scenarios_json))>0)}'
        navigate:
          - 'TRUE': add_or_update_scenario
          - 'FALSE': SUCCESS
    - get_category_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${existing_categories_json}'
            - json_path: "${\"$.items[?(@.name == '%s')].id\" % category_name}"
            - category_json: '${category_json}'
        publish:
          - category_id: '${return_result[1:-1]}'
          - deprocessed_category_json: "${category_json.replace(\"'__NULL__'\", \"null\").replace(\"'__TRUE__'\", \"true\").replace(\"'__FALSE__'\", \"false\").replace(\"'\", '\"')}"
        navigate:
          - SUCCESS: category_exists
          - FAILURE: on_failure
    - update_category:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.update_category:
            - token: '${token}'
            - id: '${category_id}'
            - category_json: '${deprocessed_category_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: contains_scenarios
    - add_or_update_scenario:
        loop:
          for: scenario_json in eval(scenarios_json)
          do:
            io.cloudslang.microfocus.rpa.demo.sub_flows.add_or_update_scenario:
              - token: '${token}'
              - category_id: '${category_id}'
              - scenario_json: '${str(scenario_json)}'
              - existing_scenarios_json: '${existing_scenarios_json}'
          break:
            - FAILURE
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - category_exists:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(category_id) > 0)}'
        navigate:
          - 'TRUE': update_category
          - 'FALSE': add_category
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_category:
        x: 198
        'y': 114
      add_or_update_scenario:
        x: 669
        'y': 114
        navigate:
          93b34fcd-e64d-b5a6-b955-f21458d8a433:
            targetId: 0a81956d-2507-67c0-0e04-41125d70c11e
            port: SUCCESS
      contains_scenarios:
        x: 419
        'y': 115
        navigate:
          44f0ecc5-0662-63aa-4995-900cc994e015:
            targetId: 0a81956d-2507-67c0-0e04-41125d70c11e
            port: 'FALSE'
      get_category_name:
        x: 39
        'y': 114
      update_category:
        x: 420
        'y': 307
      get_category_id:
        x: 43
        'y': 308
      category_exists:
        x: 199
        'y': 307
    results:
      SUCCESS:
        0a81956d-2507-67c0-0e04-41125d70c11e:
          x: 559
          'y': 314
