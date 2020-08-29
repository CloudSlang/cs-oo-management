########################################################################################################################
#!!
#! @description: Retrieves the details of the given execution
#!
#! @input run_id: The flow execution ID
#!
#! @output start_time: When the flow started (in millis)
#! @output run_status: RUNNING, COMPLETED, SYSTEM_ FAILURE, PAUSED, PENDING_ PAUSE, CANCELED, PENDING_ CANCEL
#! @output result_status_type: RESOLVED, ERROR
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.execution
flow:
  name: get_execution
  inputs:
    - run_id
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/executions/%s/summary' % run_id}"
            - method: GET
        publish:
          - run_json: '${return_result}'
          - run_pton: '${return_result.replace(":null", ":None")}'
          - start_time: "${str(eval(run_pton)[0]['startTime'])}"
          - run_status: "${eval(run_pton)[0]['status']}"
          - result_status_type: "${eval(run_pton)[0]['resultStatusType']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - run_json: '${run_json}'
    - start_time: '${start_time}'
    - run_status: '${run_status}'
    - result_status_type: '${result_status_type}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 81
        'y': 105
        navigate:
          bfe751e2-c944-88be-f3ec-c4c95625617e:
            targetId: dd9a8b88-b89a-8ccd-eeb4-9a6475b5d8e3
            port: SUCCESS
    results:
      SUCCESS:
        dd9a8b88-b89a-8ccd-eeb4-9a6475b5d8e3:
          x: 262
          'y': 108
