########################################################################################################################
#!!
#! @description: Imports the provided CP and optionally assigns it to the user default workspace.
#!               When the CP has been already imported, it just assigns the CP to the workspace.
#!
#! @input cp_file: Path to CP to be deployed
#! @input ws_id: If given, the imported CP will be also assigned to the given WS
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack
flow:
  name: import_cp
  inputs:
    - token
    - cp_file
    - ws_id:
        required: false
  workflow:
    - get_cp_properties:
        do:
          io.cloudslang.base.utils.get_cp_properties:
            - cp_file: '${cp_file}'
        publish:
          - cp_name
          - cp_version
        navigate:
          - SUCCESS: get_existing_cp_id
    - deploy_cp:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.deploy_cp:
            - token: '${token}'
            - cp_file: '${cp_file}'
        publish:
          - status_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_cp_name
          - ALREADY_DEPLOYED: get_failed_cp_name
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
          io.cloudslang.microfocus.rpa.designer.content-pack.get_cp_id:
            - cp_name: '${cp_name}'
            - cp_version: '${cp_version}'
        publish:
          - cp_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_ws_id_given
    - assign_cp:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.assign_cp:
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
          io.cloudslang.microfocus.rpa.designer.content-pack.get_cp_id:
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
          - 'TRUE': is_ws_id_given
          - 'FALSE': deploy_cp
    - is_ws_id_given:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(ws_id is not None)}'
        navigate:
          - 'TRUE': assign_cp
          - 'FALSE': SUCCESS
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
      deploy_cp:
        x: 166
        'y': 263
      is_ws_id_given:
        x: 569
        'y': 580
        navigate:
          a3c637d2-f60c-6509-9db5-4695e1104801:
            targetId: bd8aeb85-c6b9-b7a0-e088-8d020ab18e35
            port: 'FALSE'
      get_cp_version:
        x: 439
        'y': 103
      get_cp_name:
        x: 255
        'y': 100
      get_cp_properties:
        x: 51
        'y': 106
      assign_cp:
        x: 747
        'y': 581
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
          x: 743
          'y': 268
