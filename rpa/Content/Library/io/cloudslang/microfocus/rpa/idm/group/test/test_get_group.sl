namespace: io.cloudslang.microfocus.rpa.idm.group.test
flow:
  name: test_get_group
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_organization_id
    - get_group:
        do:
          io.cloudslang.microfocus.rpa.idm.group.get_group:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_name: ADMINISTRATOR
        publish:
          - group_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - get_organization_id:
        do:
          io.cloudslang.microfocus.rpa.idm.organization.get_organization_id:
            - token: '${token}'
        publish:
          - org_id
        navigate:
          - SUCCESS: get_group
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${group_json}'
            - json_path: $.groupInfo
        publish:
          - group_info: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${group_info}'
            - second_string: Administration group
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 46
        'y': 104
      get_group:
        x: 381
        'y': 113
      get_organization_id:
        x: 208
        'y': 106
      json_path_query:
        x: 62
        'y': 297
      string_equals:
        x: 230
        'y': 295
        navigate:
          c3c134fe-7a43-fa0d-bb9b-5c4b1de0d31a:
            targetId: a4dfc10c-fdcd-fce8-6f7c-fe08bb4ed74f
            port: SUCCESS
    results:
      SUCCESS:
        a4dfc10c-fdcd-fce8-6f7c-fe08bb4ed74f:
          x: 392
          'y': 292
