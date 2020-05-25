########################################################################################################################
#!!
#! @description: Imports the provided CP and assigns it to the user default workspace.
#!               When the CP has been already imported, it just assigns the CP to the workspace.
#!
#! @input cp_file: Path to CP to be deployed
#!!#
########################################################################################################################
namespace: rpa.designer.rest.content-pack
flow:
  name: import_and_assign_cp
  inputs:
    - token
    - cp_file
    - ws_id
  workflow:
    - get_cp_properties:
        do:
          rpa.tools.content_pack.get_cp_properties:
            - cp_file: '${cp_file}'
        publish:
          - cp_name
          - cp_version
        navigate:
          - SUCCESS: get_existing_cp_id
    - import_cp:
        do:
          rpa.designer.rest.dependency.import_cp:
            - token: '${token}'
            - cp_file: '${cp_file}'
        publish:
          - status_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_cp_name
          - ALREADY_IMPORTED: get_failed_cp_name
    - get_cp_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${status_json}'
            - json_path: '$.files.*.contentPackName'
        publish:
          - cp_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_cp_version
          - FAILURE: on_failure
    - get_cp_version:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${status_json}'
            - json_path: '$.files.*.contentPackVersion'
        publish:
          - cp_version: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_cp_id
          - FAILURE: on_failure
    - get_cp_id:
        do:
          rpa.designer.rest.content-pack.get_cp_id:
            - cp_name: '${cp_name}'
            - cp_version: '${cp_version}'
        publish:
          - cp_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: assign_cp_to_ws
    - assign_cp_to_ws:
        do:
          rpa.designer.rest.content-pack.assign_cp_to_ws:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - cp_id: '${cp_id}'
        publish:
          - status_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_failed_cp_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${status_json}'
            - json_path: $.contentPackName
        publish:
          - cp_name: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_failed_cp_version
          - FAILURE: on_failure
    - get_failed_cp_version:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${status_json}'
            - json_path: $.contentPackVersion
        publish:
          - cp_version: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_cp_id
          - FAILURE: on_failure
    - get_existing_cp_id:
        do:
          rpa.designer.rest.content-pack.get_cp_id:
            - cp_name: '${cp_name}'
            - cp_version: '${cp_version}'
        publish:
          - cp_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_cp_deployed
    - is_cp_deployed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(cp_id) > 0)}'
        navigate:
          - 'TRUE': assign_cp_to_ws
          - 'FALSE': import_cp
  outputs:
    - status_json: '${status_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_existing_cp_id:
        x: 49
        'y': 264
      is_cp_deployed:
        x: 48
        'y': 581
      get_cp_id:
        x: 574
        'y': 267
      get_failed_cp_name:
        x: 254
        'y': 436
      import_cp:
        x: 166
        'y': 263
      get_cp_version:
        x: 439
        'y': 103
      get_cp_name:
        x: 255
        'y': 100
      get_cp_properties:
        x: 51
        'y': 106
      assign_cp_to_ws:
        x: 704
        'y': 580
        navigate:
          4b58c01c-cf64-47c9-0443-436c52868214:
            targetId: bd8aeb85-c6b9-b7a0-e088-8d020ab18e35
            port: SUCCESS
      get_failed_cp_version:
        x: 436
        'y': 432
    results:
      SUCCESS:
        bd8aeb85-c6b9-b7a0-e088-8d020ab18e35:
          x: 700
          'y': 109
