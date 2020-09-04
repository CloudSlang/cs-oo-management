########################################################################################################################
#!!
#! @description: Updates an existing SSX category.
#!
#! @input token: X-CSRF-TOKEN obtained from get_token flow
#! @input id: ID of the category to be updated
#! @input category_json: The new content of the category
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.category
flow:
  name: update_category
  inputs:
    - token
    - id
    - category_json
  workflow:
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: "${'/rest/v0/categories/%s' % id}"
            - token: '${token}'
            - method: PUT
            - body: '${category_json}'
        publish:
          - category_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - new_category_json: '${category_json}'
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
          01bfd8df-b5cc-d5d8-e605-029116efa21c:
            targetId: 0fc33028-6982-ffb4-682f-4b28028d19fe
            port: SUCCESS
    results:
      SUCCESS:
        0fc33028-6982-ffb4-682f-4b28028d19fe:
          x: 271
          'y': 79
