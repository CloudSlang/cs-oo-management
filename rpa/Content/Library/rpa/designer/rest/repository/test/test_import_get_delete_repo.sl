namespace: rpa.designer.rest.repository.test
flow:
  name: test_import_get_delete_repo
  inputs:
    - ws_user: aosdev
    - ws_password: Cloud@123
    - ws_tenant: RPA
    - scm_url: 'https://github.com/pe-pan/rpa-aos'
  workflow:
    - get_token:
        do:
          rpa.designer.rest.authenticate.get_token:
            - ws_user: '${ws_user}'
            - ws_password: '${ws_password}'
            - ws_tenant: '${ws_tenant}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - import_repo:
        do:
          rpa.designer.rest.repository.import_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - scm_url: '${scm_url}'
        publish:
          - status_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - get_default_ws_id:
        do:
          rpa.designer.rest.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_repo
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${status_json}'
            - json_path: $.actionResult.repoId
        publish:
          - repo_id_from_import: '${return_result}'
        navigate:
          - SUCCESS: get_repo_id
          - FAILURE: on_failure
    - delete_repo:
        do:
          rpa.designer.rest.repository.delete_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - repo_id: '${repo_id_from_get}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_repo_id:
        do:
          rpa.designer.rest.repository.get_repo_id:
            - ws_id: '${ws_id}'
            - scm_url: '${scm_url}'
        publish:
          - repo_id_from_get: '${repo_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: string_equals
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${repo_id_from_get}'
            - second_string: '${repo_id_from_import}'
        navigate:
          - SUCCESS: delete_repo
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 95
        'y': 118
      import_repo:
        x: 432
        'y': 112
      get_default_ws_id:
        x: 255
        'y': 107
      string_equals:
        x: 269
        'y': 316
      delete_repo:
        x: 434
        'y': 317
        navigate:
          d0e1cff0-fa6a-e417-1509-05051196e16b:
            targetId: f73b5bc4-c0ac-3bd7-fe48-91a8e05ee270
            port: SUCCESS
      get_repo_id:
        x: 98
        'y': 309
      json_path_query:
        x: 580
        'y': 118
    results:
      SUCCESS:
        f73b5bc4-c0ac-3bd7-fe48-91a8e05ee270:
          x: 585
          'y': 317
