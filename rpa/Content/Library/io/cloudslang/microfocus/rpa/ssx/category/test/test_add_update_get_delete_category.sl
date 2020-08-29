namespace: io.cloudslang.microfocus.rpa.ssx.category.test
flow:
  name: test_add_update_get_delete_category
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_category
    - add_category:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.add_category:
            - token: '${token}'
            - category_json: |-
                ${'''
                  {
                    "name": "Test Cat",
                    "description": "Test Desc",
                    "backgroundId": 200061,
                    "iconId": 200047
                  }
                '''}
        publish:
          - id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_category
    - update_category:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.update_category:
            - token: '${token}'
            - id: '${id}'
            - category_json: |-
                ${'''
                  {
                    "name": "Test Cat",
                    "description": "Test Desc New",
                    "backgroundId": 200061,
                    "iconId": 200047
                  }
                '''}
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_category
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: $.description
        publish:
          - description: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - get_category:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.get_category:
            - token: '${token}'
            - category_name: TEST CAT
        publish:
          - category_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${description}'
            - second_string: Test Desc New
        navigate:
          - SUCCESS: delete_category
          - FAILURE: on_failure
    - delete_category:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.delete_category:
            - token: '${token}'
            - id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_category_by_id
    - get_category_by_id:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.get_category_by_id:
            - token: '${token}'
            - id: '${id}'
        navigate:
          - FAILURE: SUCCESS
          - SUCCESS: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 67
        'y': 76
      add_category:
        x: 233
        'y': 75
      update_category:
        x: 385
        'y': 82
      json_path_query:
        x: 244
        'y': 235
      get_category:
        x: 65
        'y': 234
      string_equals:
        x: 410
        'y': 243
      delete_category:
        x: 73
        'y': 396
      get_category_by_id:
        x: 365
        'y': 399
        navigate:
          4c2b215f-a360-f31c-cbb0-45c96bd55371:
            targetId: 23e47cf5-50d2-173d-fe1c-9da7001ce13d
            port: SUCCESS
          e8a9c128-4d48-fab6-2d7c-a0af65a38a04:
            targetId: 73c29f2d-bc78-7f47-b090-6d8e17fde685
            port: FAILURE
    results:
      FAILURE:
        23e47cf5-50d2-173d-fe1c-9da7001ce13d:
          x: 563
          'y': 391
      SUCCESS:
        73c29f2d-bc78-7f47-b090-6d8e17fde685:
          x: 563
          'y': 252
