########################################################################################################################
#!!
#! @description: Imports the given content pack into OO Central
#!
#! @input cp_file: CP file
#!
#! @output status_json: File upload status
#! @output process_json: Last process status
#! @output process_status: FINISHED if imported fine
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.content-pack
flow:
  name: import_cp
  inputs:
    - cp_file
  workflow:
    - create_deployment:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: /rest/latest/deployments
            - method: POST
            - use_cookies: 'true'
        publish:
          - process_json: '${return_result}'
          - process_id: "${eval(process_json)['deploymentProcessId']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: upload_file
    - upload_file:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/deployments/%s/files' % process_id}"
            - method: POST
            - file: "${'content_pack=%s' % cp_file}"
        publish:
          - status_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_file
    - import_file:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/deployments/%s?force=false' % process_id}"
            - method: PUT
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_process_status
    - get_process_status:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/deployments/%s' % process_id}"
            - method: GET
        publish:
          - process_json: '${return_result}'
          - process_status: "${eval(process_json.replace(\":null\", \":None\"))['status']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_running
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: "${get_sp('io.cloudslang.microfocus.rpa.wait_time')}"
        navigate:
          - SUCCESS: get_process_status
          - FAILURE: on_failure
    - is_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${process_status}'
            - second_string: RUNNING
        navigate:
          - SUCCESS: sleep
          - FAILURE: is_finished
    - is_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${process_status}'
            - second_string: FINISHED
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - status_json: '${status_json}'
    - process_json: '${process_json}'
    - process_status: '${process_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_deployment:
        x: 62
        'y': 105
      upload_file:
        x: 266
        'y': 101
      import_file:
        x: 65
        'y': 302
      get_process_status:
        x: 268
        'y': 301
      sleep:
        x: 505
        'y': 106
      is_running:
        x: 501
        'y': 301
      is_finished:
        x: 698
        'y': 300
        navigate:
          868f1930-35b9-9957-e2d1-3682b7011fac:
            targetId: 04ce92c8-4371-d5f3-a87d-2df03c368173
            port: SUCCESS
    results:
      SUCCESS:
        04ce92c8-4371-d5f3-a87d-2df03c368173:
          x: 897
          'y': 298
