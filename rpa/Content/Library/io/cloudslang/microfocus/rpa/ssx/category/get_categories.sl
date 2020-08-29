########################################################################################################################
#!!
#! @description: Gets SSX categories.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.category
flow:
  name: get_categories
  inputs:
    - token
  workflow:
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: /rest/v0/categories
            - token: '${token}'
            - method: GET
        publish:
          - categories_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - categories_json: '${categories_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssx_http_action:
        x: 118
        'y': 115
        navigate:
          6c826634-2ee4-e707-9fd5-a7b9f053a59f:
            targetId: a3084954-a0d0-64e6-dc25-95adbf3e450a
            port: SUCCESS
    results:
      SUCCESS:
        a3084954-a0d0-64e6-dc25-95adbf3e450a:
          x: 270
          'y': 101
