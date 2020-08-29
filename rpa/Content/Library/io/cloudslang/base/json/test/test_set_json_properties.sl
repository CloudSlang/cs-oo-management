namespace: io.cloudslang.base.json.test
flow:
  name: test_set_json_properties
  workflow:
    - set_json_properties:
        do:
          io.cloudslang.base.json.set_json_properties:
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
          - SUCCESS: set_json_properties_1
          - FAILURE: on_failure
    - set_json_properties_1:
        do:
          io.cloudslang.base.json.set_json_properties:
            - json_string: '{"host":"rpa.mf-te.com","port":8458,"dbConfiguration":null}'
            - properties: 'host,port,dbConfiguration.dbType,dbConfiguration.host,dbConfiguration.port,dbConfiguration.username,dbConfiguration.password,dbConfiguration.dbName,dbConfiguration.passwordChanged'
            - values: 'rpa.mf-te.com,8458,POSTGRESQL,rpa.mf-te.com,5432,insight,Cloud@123,insight,true'
        publish:
          - result_json
        navigate:
          - SUCCESS: json_path_query_2
    - json_path_query_2:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_json}'
            - json_path: $.dbConfiguration.dbType
        publish:
          - dbType: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals_2
          - FAILURE: on_failure
    - string_equals_2:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${dbType}'
            - second_string: POSTGRESQL
        navigate:
          - SUCCESS: set_json_properties_2
          - FAILURE: on_failure
    - set_json_properties_2:
        do:
          io.cloudslang.base.json.set_json_properties:
            - json_string: '{ "id" : "" }'
            - properties: id
            - values: '{"key" : "value"}'
            - evaluate: 'true'
        publish:
          - result_json
        navigate:
          - SUCCESS: json_path_query_3
    - json_path_query_3:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_json}'
            - json_path: $.id.key
        publish:
          - value: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals_3
          - FAILURE: on_failure
    - string_equals_3:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${value}'
            - second_string: value
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      string_equals_2:
        x: 775
        'y': 268
      set_json_properties_2:
        x: 600
        'y': 271
      string_equals_3:
        x: 295
        'y': 262
        navigate:
          d5801c0d-45a4-edd3-d773-94288a392692:
            targetId: b689c4a6-1ea4-4b2e-3abe-55f519240a9e
            port: SUCCESS
      json_path_query:
        x: 226
        'y': 92
      set_json_properties:
        x: 57
        'y': 94
      string_equals:
        x: 421
        'y': 80
      json_path_query_1:
        x: 607
        'y': 80
      json_path_query_2:
        x: 977
        'y': 256
      json_path_query_3:
        x: 434
        'y': 270
      string_equals_1:
        x: 787
        'y': 91
      set_json_properties_1:
        x: 968
        'y': 90
    results:
      SUCCESS:
        b689c4a6-1ea4-4b2e-3abe-55f519240a9e:
          x: 118
          'y': 270
