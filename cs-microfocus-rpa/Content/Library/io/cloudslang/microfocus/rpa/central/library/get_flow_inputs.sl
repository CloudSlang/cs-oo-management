########################################################################################################################
#!!
#! @description: Retrieves the details of inputs of the given flow.
#!
#! @input flow_uuid: The flow to obtain the input details 
#!
#! @output flow_inputs_json: JSON document describing the flow inputs
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.library
flow:
  name: get_flow_inputs
  inputs:
    - flow_uuid
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/flows/%s/inputs' % flow_uuid}"
            - method: GET
        publish:
          - flow_inputs_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - flow_inputs_json: '${flow_inputs_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 60
        'y': 89
        navigate:
          85cff974-62fb-4c3a-67fe-f414cc4b0117:
            targetId: 59c51ef4-a64e-8b97-23d1-4ce2949ee81c
            port: SUCCESS
    results:
      SUCCESS:
        59c51ef4-a64e-8b97-23d1-4ce2949ee81c:
          x: 272
          'y': 86

