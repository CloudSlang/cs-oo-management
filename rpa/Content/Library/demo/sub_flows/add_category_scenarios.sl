########################################################################################################################
#!!
#! @input category: Values of the single category to create
#!!#
########################################################################################################################
namespace: demo.sub_flows
flow:
  name: add_category_scenarios
  inputs:
    - token
    - category
    - value_delimiter
  workflow:
    - add_category:
        do:
          ssx.rest.category.add_category:
            - token: '${token}'
            - name: '${category.split(value_delimiter)[0]}'
            - description: '${category.split(value_delimiter)[1]}'
            - background_id: '${category.split(value_delimiter)[2]}'
            - icon_id: '${category.split(value_delimiter)[3]}'
        publish:
          - id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_true
    - add_scenario:
        loop:
          for: 'scenario_json in category.split(value_delimiter)[4:]'
          do:
            ssx.rest.scenario.add_scenario:
              - token: '${token}'
              - category_id: '${id}'
              - scenario_json: '${scenario_json}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(category.split(value_delimiter,4)[4])>0)}'
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
        x: 310
        'y': 121
        navigate:
          7778e11d-e49c-67bc-2a45-039e5e37d528:
            targetId: 0a81956d-2507-67c0-0e04-41125d70c11e
            port: SUCCESS
      is_true:
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
