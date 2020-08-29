namespace: io.cloudslang.microfocus.rpa.central.execution.test
flow:
  name: test_execute_flow
  inputs:
    - flow_uuid: rpa.central.rest.content-pack.import_cp
    - flow_inputs: "{\"cp_file\": \"C:\\\\Users\\\\Administrator\\\\Downloads\\\\content-packs\\\\SAP-cp-1.0.6.jar\"}"
  workflow:
    - execute_flow_error:
        do:
          io.cloudslang.microfocus.rpa.central.execution.execute_flow:
            - flow_uuid: '${flow_uuid}'
            - flow_inputs: '{"cp_file": "error"}'
            - timeout: '1'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE_TIMED_OUT: FAILURE
          - FAILURE_UNCOMPLETED: FAILURE
          - FAILURE: execute_flow_timeout
    - execute_flow_timeout:
        do:
          io.cloudslang.microfocus.rpa.central.execution.execute_flow:
            - flow_uuid: '${flow_uuid}'
            - flow_inputs: '${flow_inputs}'
            - timeout: '1'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE_TIMED_OUT: execute_flow
          - FAILURE_UNCOMPLETED: FAILURE
          - FAILURE: on_failure
    - execute_flow:
        do:
          io.cloudslang.microfocus.rpa.central.execution.execute_flow:
            - flow_uuid: '${flow_uuid}'
            - flow_inputs: '${flow_inputs}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE_TIMED_OUT: FAILURE
          - FAILURE_UNCOMPLETED: FAILURE
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      execute_flow_error:
        x: 69
        'y': 73
        navigate:
          0b18b05c-912c-4ed2-981c-842c1a39a2b7:
            targetId: dba05658-89d7-9475-b4a6-92616172f395
            port: SUCCESS
          202274fd-5a2a-2de7-2e82-18eaed7dd98f:
            targetId: dba05658-89d7-9475-b4a6-92616172f395
            port: FAILURE_TIMED_OUT
          9484bb43-9ce7-8467-bfa7-f537fb3c0da1:
            targetId: dba05658-89d7-9475-b4a6-92616172f395
            port: FAILURE_UNCOMPLETED
      execute_flow_timeout:
        x: 322
        'y': 71
        navigate:
          ae86bd3f-9f47-5566-d3d3-688639374b82:
            targetId: dba05658-89d7-9475-b4a6-92616172f395
            port: SUCCESS
          e5d69b7c-c200-aeef-0c53-4501f03b4ed9:
            targetId: dba05658-89d7-9475-b4a6-92616172f395
            port: FAILURE_UNCOMPLETED
      execute_flow:
        x: 566
        'y': 71
        navigate:
          7652d3af-f4a2-9af1-ba34-f979398ba7e3:
            targetId: 4a054864-e5a5-6359-2965-59fc231cfe8d
            port: SUCCESS
          adedcd09-3a26-c4d6-f4cd-5657eaf375f8:
            targetId: dba05658-89d7-9475-b4a6-92616172f395
            port: FAILURE_TIMED_OUT
          61fb32aa-a840-d0c3-9d8b-9aba3f83d6bf:
            targetId: dba05658-89d7-9475-b4a6-92616172f395
            port: FAILURE_UNCOMPLETED
    results:
      FAILURE:
        dba05658-89d7-9475-b4a6-92616172f395:
          x: 313
          'y': 338
      SUCCESS:
        4a054864-e5a5-6359-2965-59fc231cfe8d:
          x: 798
          'y': 67
