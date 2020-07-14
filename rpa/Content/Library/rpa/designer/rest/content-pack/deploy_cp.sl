########################################################################################################################
#!!
#! @description: Deploys the given Content Pack (but does not assign it to any workspace yet).
#!
#! @input cp_file: Full file path to the CP to be imported
#!
#! @output process_status: FINISHED, RUNNING
#!!#
########################################################################################################################
namespace: rpa.designer.rest.content-pack
flow:
  name: deploy_cp
  inputs:
    - token
    - cp_file
  workflow:
    - init_process:
        do:
          rpa.tools.designer_http_action:
            - url: /rest/v0/imports
            - token: '${token}'
            - method: POST
        publish:
          - process_id: "${eval(return_result)['importProcessId']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: upload_file
    - is_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${process_status}'
            - second_string: FINISHED
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
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
    - is_conflict:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '409'
        navigate:
          - SUCCESS: ALREADY_DEPLOYED
          - FAILURE: on_failure
    - upload_file:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/imports/%s/files' % process_id}"
            - token: '${token}'
            - method: POST
            - file: "${'content_pack=%s' % cp_file}"
        publish:
          - status_json: '${return_result}'
          - status_code
        navigate:
          - FAILURE: is_conflict
          - SUCCESS: import_file
    - import_file:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/imports/%s' % process_id}"
            - token: '${token}'
            - method: PUT
            - verify_result: nothing
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_process_status
    - get_process_status:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/imports/%s' % process_id}"
            - method: GET
        publish:
          - process_json: '${return_result}'
          - process_status: "${eval(return_result.replace(\":null\",\":None\"))['status']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_running
  outputs:
    - status_json: '${status_json}'
    - process_json: '${process_json}'
    - process_status: '${process_status}'
  results:
    - FAILURE
    - SUCCESS
    - ALREADY_DEPLOYED
extensions:
  graph:
    steps:
      init_process:
        x: 67
        'y': 88
      is_finished:
        x: 480
        'y': 90
        navigate:
          f6ad8242-9265-fc90-ce39-875f8422e0cd:
            targetId: f696bea6-ac0f-bce0-95b0-ddd5910e644f
            port: SUCCESS
          af169f0a-abca-dc9f-3ee4-de9558a93b14:
            targetId: d3b8300d-e188-c416-ef28-1e39ad7b01ca
            port: FAILURE
      is_running:
        x: 478
        'y': 283
      sleep:
        x: 482
        'y': 474
      is_conflict:
        x: 268
        'y': 278
        navigate:
          77e9f96d-dc65-8b88-db51-54f9f664ae54:
            targetId: ec94d070-3671-b85d-bb3e-86645be5203e
            port: SUCCESS
      upload_file:
        x: 67
        'y': 281
      import_file:
        x: 66
        'y': 473
      get_process_status:
        x: 272
        'y': 475
    results:
      FAILURE:
        d3b8300d-e188-c416-ef28-1e39ad7b01ca:
          x: 655
          'y': 282
      SUCCESS:
        f696bea6-ac0f-bce0-95b0-ddd5910e644f:
          x: 646
          'y': 87
      ALREADY_DEPLOYED:
        ec94d070-3671-b85d-bb3e-86645be5203e:
          x: 264
          'y': 75
