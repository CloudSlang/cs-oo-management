namespace: rpa.designer.rest.content-pack.test
flow:
  name: test_get_cps
  inputs:
    - cp_name: Base
    - cp_version:
        default: 1.18.0
        required: true
  workflow:
    - get_token:
        do:
          rpa.designer.rest.authenticate.get_token: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_cp_id
    - get_cp_id:
        do:
          rpa.designer.rest.content-pack.get_cp_id:
            - cp_name: '${cp_name}'
            - cp_version: '${cp_version}'
        publish:
          - cp_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: one_result_found
    - one_result_found:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(len(cp_id) > 0 and not ',' in cp_id)}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 81
        'y': 84
      get_cp_id:
        x: 239
        'y': 91
      one_result_found:
        x: 397
        'y': 94
        navigate:
          c0f7bdef-c82c-54e6-e09d-40356d801a2a:
            targetId: 9a051bd7-ab6b-f5dc-dce9-cbea71a3ed7c
            port: 'TRUE'
          82898ec5-92c8-0ecb-f3e7-faef6554173e:
            targetId: 4a881193-c23d-dbda-ecd2-c196cbef5a1c
            port: 'FALSE'
    results:
      FAILURE:
        4a881193-c23d-dbda-ecd2-c196cbef5a1c:
          x: 393
          'y': 299
      SUCCESS:
        9a051bd7-ab6b-f5dc-dce9-cbea71a3ed7c:
          x: 568
          'y': 90
