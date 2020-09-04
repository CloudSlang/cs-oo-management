########################################################################################################################
#!!
#! @description: Enables insight service.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.insight
flow:
  name: enable_insight_service
  inputs:
    - enable:
        default: 'true'
        required: true
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: /rest/v1/components/insights/enablement
            - method: PUT
            - body: "${'{\"enabled\": %s}' % enable}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 66
        'y': 96
        navigate:
          f57177bf-5b1c-5fd5-2693-d3bf57ff05e2:
            targetId: 09094539-47d7-bd04-52e6-dece33ec93c3
            port: SUCCESS
    results:
      SUCCESS:
        09094539-47d7-bd04-52e6-dece33ec93c3:
          x: 247
          'y': 101
