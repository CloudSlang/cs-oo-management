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
                    "unlockToDisabledThreshold": 2
                  }'''}
            - properties: name
            - values: TestPolicy
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
        x: 442
        'y': 92
        navigate:
          3c882620-069e-5455-a72c-84b1304aea54:
            targetId: b689c4a6-1ea4-4b2e-3abe-55f519240a9e
            port: SUCCESS
    results:
      SUCCESS:
        b689c4a6-1ea4-4b2e-3abe-55f519240a9e:
          x: 539
          'y': 116
