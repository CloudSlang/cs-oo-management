########################################################################################################################
#!!
#! @description: Schedules a flow in scheduler.
#!
#! @input name: Name of the flow schedule
#! @input flow_uuid: Flow UUID to be scheduled
#! @input trigger_expression: How often to schedule the flow; */60000 = every minute;*/3600000 = every hour
#! @input start_date: When is the flow first occurence suppose to happen; if in past, it will get scheduled immediately; should be in this format: 2010-10-21T21:47:00.000+00:00
#! @input flow_inputs: JSON document describing the flow inputs or empty for no imputs (the same as {})
#! @input time_zone: Time zone in which the flow will be scheduled
#! @input num_of_occurences: Number of times the flow will be scheduled; 0 = infinite
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.scheduler
flow:
  name: schedule_flow
  inputs:
    - name
    - flow_uuid
    - trigger_expression:
        default: '*/60000'
        required: true
    - start_date
    - flow_inputs:
        required: false
    - time_zone:
        default: Etc/GMT
        required: true
    - num_of_occurences: '0'
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: /rest/latest/schedules
            - method: POST
            - body: |-
                ${'''
                  {
                    "flowScheduleName": "%s",
                    "flowUuid": "%s",
                    "triggerExpression": "%s",
                    "startDate": "%s",
                    "inputs": %s,
                    "sensitiveInputs": {},
                    "runLogLevel": null,
                    "timeZone": "%s",
                    "enabled": true,
                    "inputPromptUseBlank": false,
                    "misfireInstruction": null,
                    "numOfOccurrences": "%s"
                  }
                ''' % (name, flow_uuid, trigger_expression, start_date, '{}' if flow_inputs is None else flow_inputs, time_zone, num_of_occurences)}
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
        x: 125
        'y': 127
        navigate:
          65d7d88a-060a-7df5-2000-22f388b6c53a:
            targetId: 738f860d-c978-2e9a-3cee-bc6fdf544d80
            port: SUCCESS
    results:
      SUCCESS:
        738f860d-c978-2e9a-3cee-bc6fdf544d80:
          x: 305
          'y': 129
