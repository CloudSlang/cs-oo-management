########################################################################################################################
#!!
#! @input category_json: Values of the single category to create
#! @input scenarios_json: List of scenarios to be added under the category
#!!#
########################################################################################################################
namespace: rpa.demo.sub_flows
flow:
  name: add_category_scenarios
  inputs:
    - token
    - category_json
    - scenarios_json
  workflow:
    - add_category:
        do:
          rpa.ssx.rest.category.add_category:
            - token: '${token}'
            - category_json: "${str(category_json).replace(\"'__NULL__'\", \"null\").replace(\"'\", '\"')}"
        publish:
          - id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: contains_scenarios
    - add_scenario:
        loop:
          for: scenario_json in eval(scenarios_json)
          do:
            rpa.ssx.rest.scenario.add_scenario:
              - token: '${token}'
              - category_id: '${id}'
              - scenario_json: "${str(scenario_json).replace(\"'__NULL__'\", \"null\").replace(\"'%s'\",\"%s\").replace(\"': True\", \"': true\").replace(\"': False\", \"': false\").replace(\"'\", '\"').replace(\"__QUOTE__\",\"'\")}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - contains_scenarios:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(scenarios_json))>0)}'
        navigate:
          - 'TRUE': add_scenario
          - 'FALSE': SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_category:
        x: 68
        'y': 115
      add_scenario:
        x: 372
        'y': 115
        navigate:
          7778e11d-e49c-67bc-2a45-039e5e37d528:
            targetId: 0a81956d-2507-67c0-0e04-41125d70c11e
            port: SUCCESS
      contains_scenarios:
        x: 225
        'y': 108
        navigate:
          44f0ecc5-0662-63aa-4995-900cc994e015:
            targetId: 0a81956d-2507-67c0-0e04-41125d70c11e
            port: 'FALSE'
    results:
      SUCCESS:
        0a81956d-2507-67c0-0e04-41125d70c11e:
          x: 314
          'y': 312
