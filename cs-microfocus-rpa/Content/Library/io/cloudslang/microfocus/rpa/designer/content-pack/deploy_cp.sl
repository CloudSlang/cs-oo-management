########################################################################################################################
#!!
#! @description: Deploys the given Content Pack (but does not assign it to any workspace yet).
#!
#! @input cp_file: Full file path to the CP to be imported
#! @input retries: How many times to retry if CP import gets into conflict
#!
#! @output process_status: FINISHED, RUNNING
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack
flow:
  name: deploy_cp
  inputs:
    - token
    - cp_file
    - retries:
        default: '20'
        private: true
  workflow:
    - init_process:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
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
            - seconds: "${get_sp('io.cloudslang.microfocus.rpa.wait_time')}"
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
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
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
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/imports/%s' % process_id}"
            - token: '${token}'
            - method: PUT
            - verify_result: nothing
        publish:
          - status_code
        navigate:
          - FAILURE: is_conflict_import
          - SUCCESS: get_process_status
    - get_process_status:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/imports/%s' % process_id}"
            - method: GET
        publish:
          - process_json: '${return_result}'
          - process_status: "${eval(return_result.replace(\":null\",\":None\"))['status']}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_running
    - is_conflict_import:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '409'
        navigate:
          - SUCCESS: shall_retry
          - FAILURE: FAILURE
    - shall_retry:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(int(retries) > 0)}'
            - retries: '${retries}'
        publish:
          - retries: '${str(int(retries)-1)}'
        navigate:
          - 'TRUE': sleep_retry
          - 'FALSE': FAILURE
    - sleep_retry:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: "${str(int(get_sp('io.cloudslang.microfocus.rpa.wait_time')) * 2)}"
        navigate:
          - SUCCESS: import_file
          - FAILURE: on_failure
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
      sleep_retry:
        x: 469
        'y': 672
      is_conflict:
        x: 268
        'y': 278
        navigate:
          77e9f96d-dc65-8b88-db51-54f9f664ae54:
            targetId: ec94d070-3671-b85d-bb3e-86645be5203e
            port: SUCCESS
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
      get_process_status:
        x: 272
        'y': 475
      shall_retry:
        x: 274
        'y': 668
        navigate:
          653222d7-c7df-1b08-5eb0-22cc975c8640:
            targetId: dcd369bd-bfcf-24f8-55ba-aae0c835b9b7
            port: 'FALSE'
      import_file:
        x: 66
        'y': 473
      sleep:
        x: 482
        'y': 474
      upload_file:
        x: 67
        'y': 281
      is_conflict_import:
        x: 63
        'y': 663
        navigate:
          e9df5533-325a-97e9-0f3c-a5a209a5b51b:
            targetId: dcd369bd-bfcf-24f8-55ba-aae0c835b9b7
            port: FAILURE
    results:
      FAILURE:
        d3b8300d-e188-c416-ef28-1e39ad7b01ca:
          x: 655
          'y': 282
        dcd369bd-bfcf-24f8-55ba-aae0c835b9b7:
          x: 269
          'y': 847
      SUCCESS:
        f696bea6-ac0f-bce0-95b0-ddd5910e644f:
          x: 646
          'y': 87
      ALREADY_DEPLOYED:
        ec94d070-3671-b85d-bb3e-86645be5203e:
          x: 264
          'y': 75
