namespace: io.cloudslang.microfocus.rpa.idm.user.test
flow:
  name: test_add_get_delete_user
  inputs:
    - username: salesforcedev9
    - password: Cloud@123
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_organization_id
    - add_user:
        do:
          io.cloudslang.microfocus.rpa.idm.user.add_user:
            - token: '${token}'
            - username: '${username}'
            - password: '${password}'
            - org_id: '${org_id}'
        publish:
          - user_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_user_id
    - get_organization_id:
        do:
          io.cloudslang.microfocus.rpa.idm.organization.get_organization_id:
            - token: '${token}'
        publish:
          - org_id
        navigate:
          - SUCCESS: add_user
          - FAILURE: on_failure
    - get_user:
        do:
          io.cloudslang.microfocus.rpa.idm.user.get_user:
            - token: '${token}'
            - username_or_id: '${username}'
            - org_id: '${org_id}'
        publish:
          - user_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: filter_user_id
    - get_user_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${user_json}'
            - json_path: $.abstractUserId
        publish:
          - created_user_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_user
          - FAILURE: on_failure
    - filter_user_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${user_json}'
            - json_path: $.id
        publish:
          - user_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: ids_equal
          - FAILURE: on_failure
    - ids_equal:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${created_user_id}'
            - second_string: '${user_id}'
        navigate:
          - SUCCESS: delete_user
          - FAILURE: on_failure
    - delete_user:
        do:
          io.cloudslang.microfocus.rpa.idm.user.delete_user:
            - token: '${token}'
            - username_or_id: '${username}'
            - org_id: '${org_id}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_users
    - get_users:
        do:
          io.cloudslang.microfocus.rpa.idm.user.get_users:
            - token: '${token}'
            - searchText: '${username}'
            - org_id: '${org_id}'
        publish:
          - users_json
          - total: "${str(eval(users_json)['total'])}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: none_found
    - none_found:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${total}'
            - second_string: '0'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_user_id:
        x: 563
        'y': 86
      filter_user_id:
        x: 226
        'y': 269
      add_user:
        x: 391
        'y': 92
      ids_equal:
        x: 409
        'y': 269
      get_token:
        x: 53
        'y': 91
      get_user:
        x: 54
        'y': 258
      none_found:
        x: 422
        'y': 442
        navigate:
          d304f5b0-61fc-1fb3-7ac9-182ebb2dbafb:
            targetId: 2a70c61f-a4f0-f205-b72e-68c138b90067
            port: SUCCESS
      get_organization_id:
        x: 224
        'y': 94
      delete_user:
        x: 63
        'y': 448
      get_users:
        x: 239
        'y': 447
    results:
      SUCCESS:
        2a70c61f-a4f0-f205-b72e-68c138b90067:
          x: 565
          'y': 257
