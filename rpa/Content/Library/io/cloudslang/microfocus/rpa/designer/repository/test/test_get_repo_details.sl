namespace: io.cloudslang.microfocus.rpa.designer.repository.test
flow:
  name: test_get_repo_details
  inputs:
    - ws_user: aosdev
    - expected_scm_url: 'https://github.com/pe-pan/rpa-aos.git'
    - expected_repo_owner: pe-pan
    - expected_repo_name: rpa-aos
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${ws_user}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - get_default_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_repo_details
    - get_repo_details:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.get_repo_details:
            - ws_id: '${ws_id}'
        publish:
          - repo_id
          - scm_url
          - repo_owner
          - repo_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_scm_url
    - check_repo_name:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${repo_name}'
            - second_string: '${expected_repo_name}'
        navigate:
          - SUCCESS: check_owner_name
          - FAILURE: on_failure
    - check_owner_name:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${repo_owner}'
            - second_string: '${expected_repo_owner}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_scm_url:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(expected_scm_url.startswith(scm_url))}'
        navigate:
          - 'TRUE': check_repo_name
          - 'FALSE': FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_token:
        x: 80
        'y': 42
      get_default_ws_id:
        x: 237
        'y': 43
      get_repo_details:
        x: 396
        'y': 44
      check_scm_url:
        x: 86
        'y': 231
        navigate:
          ec4d5e5c-7d07-d1cc-bb31-48a9e998050c:
            targetId: aca27f5f-d430-40f3-8f90-38b918ca602b
            port: 'FALSE'
      check_repo_name:
        x: 315
        'y': 235
      check_owner_name:
        x: 499
        'y': 242
        navigate:
          cbf4e8d4-af4b-7835-ae94-958eef901b75:
            targetId: cb00cdab-90e6-fb0b-9cb8-05223e5dd6e3
            port: SUCCESS
    results:
      SUCCESS:
        cb00cdab-90e6-fb0b-9cb8-05223e5dd6e3:
          x: 575
          'y': 44
      FAILURE:
        aca27f5f-d430-40f3-8f90-38b918ca602b:
          x: 216
          'y': 393
