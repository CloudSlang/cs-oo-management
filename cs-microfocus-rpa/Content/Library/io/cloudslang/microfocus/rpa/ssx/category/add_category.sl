########################################################################################################################
#!!
#! @description: Adds an SSX category.
#!
#! @input token: X-CSRF-TOKEN obtained from get_token flow
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.category
flow:
  name: add_category
  inputs:
    - token
    - category_json
  workflow:
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: /rest/v0/categories
            - token: '${token}'
            - method: POST
            - body: '${category_json}'
        publish:
          - category_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
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
        x: 80
        'y': 80
      json_path_query:
        x: 226
        'y': 87
        navigate:
          4390a84b-69ef-f916-11a3-8a745f6ef87f:
            targetId: 0fc33028-6982-ffb4-682f-4b28028d19fe
            port: SUCCESS
    results:
      SUCCESS:
        0fc33028-6982-ffb4-682f-4b28028d19fe:
          x: 381
          'y': 83
