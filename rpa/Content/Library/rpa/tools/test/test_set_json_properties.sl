namespace: rpa.tools.test
flow:
  name: test_set_json_properties
  workflow:
    - set_json_properties:
        do:
          rpa.tools.set_json_properties:
            - json_string: |-
                ${'''{
                    "id": "2c906fdc6e9009eb016e900a019f00ce",
                    "name": "DefaultPolicy",
                    "upperAndLowerCase": true,
                    "numerical": true,
                    "specialChar": true,
                    "infoSensitive": true,
                    "historyCheck": true,
                    "lengthCheck": true,
                    "expirationCheck": true,
                    "minLength": 8,
                    "maxLength": 20,
                    "duration": 90,
                    "lockoutThreshold": 5,
                    "lockoutDuration": 90,
                    "idleDay": 90,
                    "unlockToDisabledThreshold": 2,
                    "dbConf" : {
                        "name" : "PSQL"
                    }
                  }'''}
            - properties: 'name,dbConf.name'
            - values: 'TestPolicy,ORACLE'
        publish:
          - result_json
        navigate:
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_json}'
            - json_path: $.name
        publish:
          - name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${name}'
            - second_string: TestPolicy
            - ignore_case: null
        navigate:
          - SUCCESS: json_path_query_1
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_json}'
            - json_path: $.dbConf.name
        publish:
          - dbName: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals_1
          - FAILURE: on_failure
    - string_equals_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${dbName}'
            - second_string: ORACLE
            - ignore_case: null
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_json_properties:
        x: 57
        'y': 94
      json_path_query:
        x: 241
        'y': 101
      string_equals:
        x: 424
        'y': 99
      json_path_query_1:
        x: 241
        'y': 256
      string_equals_1:
        x: 417
        'y': 257
        navigate:
          51083df6-7a83-14dc-6f23-182b0fed196a:
            targetId: b689c4a6-1ea4-4b2e-3abe-55f519240a9e
            port: SUCCESS
    results:
      SUCCESS:
        b689c4a6-1ea4-4b2e-3abe-55f519240a9e:
          x: 602
          'y': 99
