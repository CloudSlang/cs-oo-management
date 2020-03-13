########################################################################################################################
#!!
#! @description: Schedules a flow in scheduler.
#!
#! @input name: Schedule name
#! @input uuid: Flow UUID
#! @input trigger_expression: */60000 = every minute;*/3600000 = every hour
#! @input inputs: ROI
#! @input num_of_occurences: 0 = infinite
#!!#
########################################################################################################################
namespace: central.rest.scheduler
flow:
  name: schedule_flow
  inputs:
    - name: Change Yahoo Password
    - uuid: 4dbc0a51-9b94-4718-b86c-5f296b29538c
    - trigger_expression: '*/60000'
    - start_date: '2020-03-04T16:35:00.000+00:00'
    - inputs: '"count" : "20"'
    - time_zone: Etc/GMT
    - num_of_occurences: '0'
  workflow:
    - http_client_action:
        do:
          tools.http_client_action:
            - url: "${'%s/rest/latest/schedules' % get_sp('central_url')}"
            - method: POST
            - body: |-
                ${'''
                  {
                    "flowScheduleName": "%s",
                    "flowUuid": "%s",
                    "triggerExpression": "%s",
                    "startDate": "%s",
                    "inputs": {
                      %s
                    },
                    "sensitiveInputs": {},
                    "runLogLevel": null,
                    "timeZone": "%s",
                    "enabled": true,
                    "inputPromptUseBlank": false,
                    "misfireInstruction": null,
                    "numOfOccurrences": "%s"
                  }
                ''' % (name, uuid, trigger_expression, start_date, inputs, time_zone, num_of_occurences)}
            - use_cookies: 'false'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
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
