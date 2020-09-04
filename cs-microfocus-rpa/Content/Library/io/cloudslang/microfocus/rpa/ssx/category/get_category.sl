########################################################################################################################
#!!
#! @description: Gets category by its name.
#!
#! @input token: X-CSRF-TOKEN obtained from get_token flow
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.category
flow:
  name: get_category
  inputs:
    - token
    - category_name
  workflow:
    - get_categories:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.get_categories:
            - token: '${token}'
        publish:
          - categories_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${categories_json}'
            - json_path: "${\"$.items[?(@.name == '%s')]\" % category_name}"
        publish:
          - category_json: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - category_json: '${category_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_categories:
        x: 70
        'y': 107
      json_path_query:
        x: 233
        'y': 110
        navigate:
          b286fef6-586a-1ad1-079c-f1626aed6ee7:
            targetId: 0fc33028-6982-ffb4-682f-4b28028d19fe
            port: SUCCESS
    results:
      SUCCESS:
        0fc33028-6982-ffb4-682f-4b28028d19fe:
          x: 375
          'y': 98
