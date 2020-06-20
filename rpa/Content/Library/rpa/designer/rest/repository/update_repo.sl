########################################################################################################################
#!!
#! @description: Triggers the process of updating SCM repository (pull) and waits for the process to finish.
#!
#! @output process_json: JSON of the SCM pull process
#! @output process_id: Process ID
#! @output status_json: JSON of the SCM pull process status
#! @output process_status: RUNNING, FINISHED
#!!#
########################################################################################################################
namespace: rpa.designer.rest.repository
flow:
  name: update_repo
  inputs:
    - token
    - repo_id
  workflow:
    - trigger_update_repo:
        do:
          rpa.designer.rest.repository.trigger_update_repo:
            - token: '${token}'
            - repo_id: '${repo_id}'
        publish:
          - process_json
          - process_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_process_status
    - get_process_status:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/scm/processes/%s' % process_id}"
            - token: '${token}'
            - method: GET
        publish:
          - status_json: '${return_result}'
          - process_status: "${eval(return_result.replace(\":null\", \":None\"))['actionStatus']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_running
    - is_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${process_status}'
            - second_string: RUNNING
        navigate:
          - SUCCESS: sleep
          - FAILURE: is_finished
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: "${get_sp('wait_time')}"
        navigate:
          - SUCCESS: get_process_status
          - FAILURE: on_failure
    - is_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${process_status}'
            - second_string: FINISHED
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - process_json: '${process_json}'
    - process_id: '${process_id}'
    - status_json: '${status_json}'
    - process_status: '${process_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      trigger_update_repo:
        x: 63
        'y': 105
      get_process_status:
        x: 277
        'y': 106
      is_running:
        x: 276
        'y': 315
      sleep:
        x: 66
        'y': 312
      is_finished:
        x: 473
        'y': 314
        navigate:
          a266315a-3926-7d65-5860-b8cf85a57ba1:
            targetId: e5b25c95-1de3-f15b-e0e8-bd170ce61de8
            port: SUCCESS
    results:
      SUCCESS:
        e5b25c95-1de3-f15b-e0e8-bd170ce61de8:
          x: 647
          'y': 315
