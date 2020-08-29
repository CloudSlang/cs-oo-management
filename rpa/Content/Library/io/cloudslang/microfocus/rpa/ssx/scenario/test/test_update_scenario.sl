namespace: io.cloudslang.microfocus.rpa.ssx.scenario.test
flow:
  name: test_update_scenario
  inputs:
    - scenario_json: '{"categoryId":%s,"name":"PURCHASE AN ITEM","description":"Shops for an item. Updated.","inputs":[{"label":"url","originalName":"url","type":"STRING","required":false,"exposed":true,"hasDefaultValue":true,"defaultValue":"http://rpa.mf-te.com:8080","sources":null,"separator":null},{"label":"username","originalName":"username","type":"STRING","required":true,"exposed":true,"hasDefaultValue":false,"defaultValue":null,"sources":null,"separator":null},{"label":"password","originalName":"password","type":"CREDENTIAL","required":true,"exposed":true,"hasDefaultValue":false,"defaultValue":null,"sources":null,"separator":null},{"label":"catalog","originalName":"catalog","type":"STRING","required":true,"exposed":true,"hasDefaultValue":false,"defaultValue":null,"sources":null,"separator":null},{"label":"item","originalName":"item","type":"STRING","required":true,"exposed":true,"hasDefaultValue":false,"defaultValue":null,"sources":null,"separator":null}],"outputs":[{"label":"price","originalName":"price","exposed":true}],"roles":["ADMINISTRATOR","PROMOTER"],"flowVo":{"flowUuid":"AOS.product.purchase.ui.buy_item","persistenceLevel":"STANDARD","timeoutValue":0,"flowPath":"Library/AOS/product/purchase/ui/buy_item.sl"}}'
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_scenario_name
    - update_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.update_scenario:
            - token: '${token}'
            - id: '${scenario_id}'
            - category_id: '${category_id}'
            - scenario_json: '${scenario_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_scenarios:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.get_scenarios:
            - token: '${token}'
        publish:
          - scenarios_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_scenario_id
    - get_scenario_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: "${scenario_json % '\"\"'}"
            - json_path: $.name
        publish:
          - scenario_name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_scenarios
          - FAILURE: on_failure
    - get_scenario_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${scenarios_json}'
            - json_path: "${\"$.items[?(@.name == '%s')].id\" % scenario_name}"
        publish:
          - scenario_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_category_id
          - FAILURE: on_failure
    - get_category_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${scenarios_json}'
            - json_path: "${\"$.items[?(@.name == '%s')].lightCategory.id\" % scenario_name}"
        publish:
          - category_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: update_scenario
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      update_scenario:
        x: 556
        'y': 31
        navigate:
          4ed2d6f3-0df9-6163-b102-1c840d5c0bd7:
            targetId: 42102214-c351-753a-5c4b-bfb17e0c4a55
            port: SUCCESS
      get_token:
        x: 155
        'y': 19
      get_scenarios:
        x: 212
        'y': 187
      get_scenario_name:
        x: 43
        'y': 180
      get_scenario_id:
        x: 323
        'y': 26
      get_category_id:
        x: 443
        'y': 178
    results:
      SUCCESS:
        42102214-c351-753a-5c4b-bfb17e0c4a55:
          x: 670
          'y': 177
