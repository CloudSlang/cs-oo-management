########################################################################################################################
#!!
#! @description: Triggers the given flow and waits for the flow execution to finish.
#!
#! @input flow_uuid: Flow to be executed
#! @input flow_inputs: No inputs if nothing given
#! @input timeout: Expected time (in millis) to finish the flow; if not given, infinite
#!
#! @output run_id: The flow execution ID
#! @output start_time: When the flow started (in millis)
#! @output run_status: RUNNING, COMPLETED, SYSTEM_ FAILURE, PAUSED, PENDING_ PAUSE, CANCELED, PENDING_ CANCEL
#! @output result_status_type: RESOLVED, ERROR
#!
#! @result SUCCESS: If the given flow succeeds
#! @result FAILURE_TIMED_OUT: If the flow does not finish in specified timeout
#! @result FAILURE_UNCOMPLETED: Neither RUNNING nor COMPLETED
#! @result FAILURE: If the given flow fails
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.execution
flow:
  name: execute_flow
  inputs:
    - flow_uuid
    - flow_inputs:
        required: false
    - timeout:
        required: false
  workflow:
    - trigger_flow:
        do:
          io.cloudslang.microfocus.rpa.central.execution.trigger_flow:
            - flow_uuid: '${flow_uuid}'
            - flow_inputs: '${flow_inputs}'
        publish:
          - run_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_execution
    - get_execution:
        do:
          io.cloudslang.microfocus.rpa.central.execution.get_execution:
            - run_id: '${run_id}'
        publish:
          - start_time
          - run_status
          - result_status_type
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_running
    - is_running:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(run_status == 'RUNNING')}"
        navigate:
          - 'TRUE': sleep
          - 'FALSE': is_completed
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: "${get_sp('io.cloudslang.microfocus.rpa.wait_time')}"
        navigate:
          - SUCCESS: is_timeout_given
          - FAILURE: on_failure
    - is_completed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(run_status == 'COMPLETED')}"
        navigate:
          - 'TRUE': is_resolved
          - 'FALSE': FAILURE_UNCOMPLETED
    - get_time:
        do:
          io.cloudslang.base.datetime.get_millis: []
        publish:
          - time_millis
        navigate:
          - SUCCESS: has_timed_out
    - is_timeout_given:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${timeout}'
        navigate:
          - IS_NULL: get_execution
          - IS_NOT_NULL: get_time
    - has_timed_out:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(long(time_millis)-long(start_time) > long(timeout))}'
        navigate:
          - 'TRUE': FAILURE_TIMED_OUT
          - 'FALSE': get_execution
    - is_resolved:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(result_status_type == 'RESOLVED')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  outputs:
    - run_id: '${run_id}'
    - start_time: '${start_time}'
    - run_status: '${run_status}'
    - result_status_type: '${result_status_type}'
  results:
    - SUCCESS
    - FAILURE_TIMED_OUT
    - FAILURE_UNCOMPLETED
    - FAILURE
extensions:
  graph:
    steps:
      has_timed_out:
        x: 526
        'y': 164
        navigate:
          64173ca1-0c58-b2dc-fe20-b30c8190aefa:
            targetId: c4bc9155-7428-aa44-166e-95e1f4f14341
            port: 'TRUE'
      is_timeout_given:
        x: 537
        'y': 362
      is_running:
        x: 53
        'y': 362
      is_resolved:
        x: 552
        'y': 562
        navigate:
          a880c9b6-3f94-6b8a-d9a5-711d98705bec:
            targetId: 246ff3a8-aa62-5be6-240b-8668036ea94f
            port: 'TRUE'
          aba02303-cc7e-d8a3-d57a-4a82c7a8eb17:
            targetId: 8bc94fca-1066-7315-4bb5-313e32872530
            port: 'FALSE'
      get_execution:
        x: 52
        'y': 167
      trigger_flow:
        x: 305
        'y': 24
      is_completed:
        x: 289
        'y': 563
        navigate:
          535abb09-6089-c86c-d9cf-e580b70ce631:
            targetId: 2f9d5943-8b92-0d51-20b1-b062128bae93
            port: 'FALSE'
      get_time:
        x: 752
        'y': 161
      sleep:
        x: 300
        'y': 361
    results:
      SUCCESS:
        246ff3a8-aa62-5be6-240b-8668036ea94f:
          x: 756
          'y': 563
      FAILURE_TIMED_OUT:
        c4bc9155-7428-aa44-166e-95e1f4f14341:
          x: 750
          'y': 8
      FAILURE_UNCOMPLETED:
        2f9d5943-8b92-0d51-20b1-b062128bae93:
          x: 49
          'y': 564
      FAILURE:
        8bc94fca-1066-7315-4bb5-313e32872530:
          x: 749
          'y': 397
