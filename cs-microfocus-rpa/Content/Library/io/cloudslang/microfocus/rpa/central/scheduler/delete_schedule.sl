########################################################################################################################
#!!
#! @description: Removes the given flow schedule.
#!
#! @input schedule_id: Flow schedule ID to be removed
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.scheduler
flow:
  name: delete_schedule
  inputs:
    - schedule_id
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/schedules/' + schedule_id}"
            - method: DELETE
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
        x: 54
        'y': 84
        navigate:
          0f36fdb7-41d5-6c23-fc69-6c5aa03b562d:
            targetId: 4e0a27fb-c18d-56bf-9631-084ea2cdbbde
            port: SUCCESS
    results:
      SUCCESS:
        4e0a27fb-c18d-56bf-9631-084ea2cdbbde:
          x: 227
          'y': 88
