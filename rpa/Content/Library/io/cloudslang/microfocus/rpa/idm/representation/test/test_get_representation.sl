namespace: io.cloudslang.microfocus.rpa.idm.representation.test
flow:
  name: test_get_representation
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_organization_id
    - get_representation:
        do:
          io.cloudslang.microfocus.rpa.idm.representation.get_representation:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_id: '${group_id}'
            - repre_name: OO_AGR_ADMINISTRATOR
        publish:
          - repre_json
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
          - SUCCESS: get_group_id
          - FAILURE: on_failure
    - get_group_id:
        do:
          io.cloudslang.microfocus.rpa.idm.group.get_group_id:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_name: ADMINISTRATOR
        publish:
          - group_id
        navigate:
          - SUCCESS: get_representation
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${repre_json}'
            - json_path: $.representationType
        publish:
          - representation_type: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${representation_type}'
            - second_string: DATABASE_GROUP_REPRESENTATION
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
        x: 41
        'y': 134
      get_representation:
        x: 54
        'y': 326
      get_organization_id:
        x: 214
        'y': 128
      get_group_id:
        x: 389
        'y': 135
      json_path_query:
        x: 228
        'y': 327
      string_equals:
        x: 399
        'y': 328
        navigate:
          96e48dac-c8e7-8761-eca4-096c35cdc23c:
            targetId: 7801c5bc-6b77-36c8-95ed-3e087a1a524b
            port: SUCCESS
    results:
      SUCCESS:
        7801c5bc-6b77-36c8-95ed-3e087a1a524b:
          x: 550
          'y': 234
