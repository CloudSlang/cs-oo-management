########################################################################################################################
#!!
#! @description: Imports the given Content Pack
#!
#! @input cp_file: Full file path to the CP to be imported
#! @input status_wait_time: How much time to wait between two sub-sequent get upload file process status calls.
#!!#
########################################################################################################################
namespace: rpa.designer.rest.dependency
flow:
  name: import_cp
  inputs:
    - token
    - cp_file
    - status_wait_time:
        default: '5'
        required: false
  workflow:
    - init_process:
        do:
          rpa.designer.rest.dependency.sub_flows.init_process:
            - token: '${token}'
        publish:
          - process_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: upload_file
    - import_file:
        do:
          rpa.designer.rest.dependency.sub_flows.import_file:
            - process_id: '${process_id}'
            - token: '${token}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_process_status
    - upload_file:
        do:
          rpa.designer.rest.dependency.sub_flows.upload_file:
            - process_id: '${process_id}'
            - token: '${token}'
            - cp_file: '${cp_file}'
        publish:
          - files_json
          - status_code
        navigate:
          - FAILURE: is_conflict
          - SUCCESS: import_file
    - get_process_status:
        do:
          rpa.designer.rest.dependency.sub_flows.get_process_status:
            - process_id: '${process_id}'
        publish:
          - process_status
          - process_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_running
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
            - seconds: "${get('status_wait_time', '5')}"
        navigate:
          - SUCCESS: get_process_status
          - FAILURE: on_failure
    - is_conflict:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '409'
        navigate:
          - SUCCESS: ALREADY_IMPORTED
          - FAILURE: on_failure
  outputs:
    - files_json: '${files_json}'
    - process_json: '${process_json}'
    - process_status: '${process_status}'
  results:
    - FAILURE
    - SUCCESS
    - ALREADY_IMPORTED
extensions:
  graph:
    steps:
      init_process:
        x: 68
        'y': 84
      import_file:
        x: 66
        'y': 468
      upload_file:
        x: 66
        'y': 279
      get_process_status:
        x: 265
        'y': 471
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
    results:
      FAILURE:
        d3b8300d-e188-c416-ef28-1e39ad7b01ca:
          x: 655
          'y': 282
      SUCCESS:
        f696bea6-ac0f-bce0-95b0-ddd5910e644f:
          x: 646
          'y': 87
      ALREADY_IMPORTED:
        ec94d070-3671-b85d-bb3e-86645be5203e:
          x: 264
          'y': 75
