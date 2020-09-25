########################################################################################################################
#!!
#! @description: Retrieves all flow schedules.
#!
#! @output schedules_json: List of existing flow schedules.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.scheduler
flow:
  name: get_schedules
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: /rest/latest/all-schedules
            - method: GET
        publish:
          - schedules_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - schedules_json: '${schedules_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 98
        'y': 91
        navigate:
          b93e5f15-1544-6806-31d9-37ac59362416:
            targetId: 1c113a47-7f29-c41a-7c6c-b3b804aa5aaf
            port: SUCCESS
    results:
      SUCCESS:
        1c113a47-7f29-c41a-7c6c-b3b804aa5aaf:
          x: 299
          'y': 94
