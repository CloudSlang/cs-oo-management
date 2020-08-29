namespace: io.cloudslang.microfocus.rpa.designer.repository.test
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
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
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
          io.cloudslang.microfocus.rpa.designer.repository.import_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - scm_url: '${scm_url}'
        publish:
          - status_json
          - repo_id_from_import: "${eval(status_json.replace(\":null\", \":None\"))['actionResult']['repoId']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_repo_details
    - get_default_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_repo
    - delete_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.delete_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - repo_id: '${repo_id_from_get}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${repo_id_from_get}'
            - second_string: '${repo_id_from_import}'
        navigate:
          - SUCCESS: delete_repo
          - FAILURE: on_failure
    - get_repo_details:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.get_repo_details:
            - ws_id: '${ws_id}'
        publish:
          - repo_id_from_get: '${repo_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: string_equals
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
      get_repo_details:
        x: 94
        'y': 312
    results:
      SUCCESS:
        f73b5bc4-c0ac-3bd7-fe48-91a8e05ee270:
          x: 585
          'y': 317
