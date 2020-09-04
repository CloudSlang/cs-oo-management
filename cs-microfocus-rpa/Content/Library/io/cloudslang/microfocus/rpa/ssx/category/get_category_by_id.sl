########################################################################################################################
#!!
#! @description: Adds an SSX category.
#!
#! @input token: X-CSRF-TOKEN obtained from get_token flow
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.category
flow:
  name: get_category_by_id
  inputs:
    - token
    - id
  workflow:
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: "${'/rest/v0/categories/%s' % id}"
            - token: '${token}'
            - method: GET
        publish:
          - category_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - category_json: '${category_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssx_http_action:
        x: 80
        'y': 80
        navigate:
          a9057876-2774-02f9-da4f-7b68a7b09236:
            targetId: 0fc33028-6982-ffb4-682f-4b28028d19fe
            port: SUCCESS
    results:
      SUCCESS:
        0fc33028-6982-ffb4-682f-4b28028d19fe:
          x: 254
          'y': 87
