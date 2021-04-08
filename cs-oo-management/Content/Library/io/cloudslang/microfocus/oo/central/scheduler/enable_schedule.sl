########################################################################################################################
#!!
#! @description: Enables or disables the flow schedule.
#!
#! @input schedule_id: Flow schedule to be enabled/disabled
#! @input enabled: true = schedule will be enabled; false = schedule will be disabled
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.central.scheduler
flow:
  name: enable_schedule
  inputs:
    - schedule_id
    - enabled: 'true'
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.oo.central._operations.central_http_action:
            - url: "${'/rest/latest/schedules/%s/enabled' % schedule_id}"
            - method: PUT
            - body: '${enabled}'
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
        x: 46
        'y': 80
        navigate:
          583e1c0b-852c-cb04-81e8-158e5108475f:
            targetId: 4e2785f6-241f-d5d5-82c0-42a9f5b13b59
            port: SUCCESS
    results:
      SUCCESS:
        4e2785f6-241f-d5d5-82c0-42a9f5b13b59:
          x: 260
          'y': 80
