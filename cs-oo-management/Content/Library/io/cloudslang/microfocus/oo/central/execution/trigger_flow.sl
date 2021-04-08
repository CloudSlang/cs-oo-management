########################################################################################################################
#!!
#! @description: Triggers a flow and returns immediately.
#!
#! @input flow_uuid: Flow to be executed
#! @input flow_run_name: Flow execution name shown in the execution log; the flow name if not given
#! @input flow_inputs: JSON document describing the inputs; {} if nothing given
#!
#! @output flow_run_id: The flow execution ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.central.execution
flow:
  name: trigger_flow
  inputs:
    - flow_uuid
    - flow_run_name:
        required: false
    - flow_inputs:
        required: false
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.oo.central._operations.central_http_action:
            - url: /rest/latest/executions
            - method: POST
            - body: |-
                ${'''{
                    "flowUuid":"%s",
                    %s
                    "inputs": %s,
                    "inputPromptUseBlank": true
                }''' % (flow_uuid, '' if flow_run_name is None else '"runName": "'+flow_run_name+'",','{}' if flow_inputs is None else flow_inputs)}
        publish:
          - flow_run_id: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - flow_run_id: '${flow_run_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 85
        'y': 161
        navigate:
          cf2fb818-e158-891f-78e0-ebf062b29902:
            targetId: becda1dd-d089-c83d-7a86-a6be2c106a3b
            port: SUCCESS
    results:
      SUCCESS:
        becda1dd-d089-c83d-7a86-a6be2c106a3b:
          x: 305
          'y': 162

