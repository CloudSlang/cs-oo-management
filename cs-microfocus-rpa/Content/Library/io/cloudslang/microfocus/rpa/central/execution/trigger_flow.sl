########################################################################################################################
#!!
#! @description: Triggers a flow and returns immediately.
#!
#! @input flow_uuid: Flow to be executed
#! @input flow_inputs: JSON document describing the inputs; {} if nothing given
#!
#! @output run_id: The flow execution ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.execution
flow:
  name: trigger_flow
  inputs:
    - flow_uuid
    - flow_inputs:
        required: false
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: /rest/latest/executions
            - method: POST
            - body: |-
                ${'''{
                    "flowUuid":"%s",
                    "inputs": %s,
                    "inputPromptUseBlank": true
                }''' % (flow_uuid, '{}' if flow_inputs is None else flow_inputs)}
        publish:
          - run_id: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - run_id: '${run_id}'
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
