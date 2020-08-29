namespace: io.cloudslang.microfocus.rpa.designer.content-pack.test
flow:
  name: test_get_assigned_cps
  inputs:
    - cp_name: Base
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token: []
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
          - SUCCESS: get_assigned_cp_id
    - one_result_found:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(len(cp_id) > 0 and not ',' in cp_id)}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
    - get_assigned_cp_id:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.get_assigned_cp_id:
            - ws_id: '${ws_id}'
            - cp_name: '${cp_name}'
        publish:
          - cp_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: one_result_found
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_assigned_cp_id:
        x: 413
        'y': 109
      get_default_ws_id:
        x: 251
        'y': 96
      get_token:
        x: 73
        'y': 95
      one_result_found:
        x: 584
        'y': 111
        navigate:
          fa845ba7-127a-7e70-1ba9-b5814eee54eb:
            targetId: 5dc20709-f5a9-10c9-b782-bea1bb4cb6f3
            port: 'TRUE'
          f791bd84-929b-61df-7aff-dcb37c2ed3c8:
            targetId: 54bf1155-e871-e8da-c8e0-f60ccc2c547d
            port: 'FALSE'
    results:
      SUCCESS:
        5dc20709-f5a9-10c9-b782-bea1bb4cb6f3:
          x: 747
          'y': 100
      FAILURE:
        54bf1155-e871-e8da-c8e0-f60ccc2c547d:
          x: 585
          'y': 292
