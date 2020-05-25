########################################################################################################################
#!!
#! @description: Downloads a CP from URL, imports that into Designer and assigns it to a workspace
#!
#! @input cp_url: URL pointing to a CP
#! @input file_path: If given, the downloaded CP will be placed to this file (otherwise temporal will be created and removed later)
#!!#
########################################################################################################################
namespace: rpa.designer.rest.content-pack
flow:
  name: download_import_and_assign_cp
  inputs:
    - token
    - cp_url
    - ws_id
    - file_path:
        required: false
  workflow:
    - file_path_given:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(file_path is not None)}'
        publish:
          - folder_path: ''
        navigate:
          - 'TRUE': download_cp
          - 'FALSE': get_temp_file
    - download_cp:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${cp_url}'
            - auth_type: anonymous
            - destination_file: '${file_path}'
            - content_type: application/octet-stream
            - method: GET
        navigate:
          - SUCCESS: import_and_assign_cp
          - FAILURE: on_failure
    - get_temp_file:
        do:
          rpa.tools.temp.get_temp_file:
            - file_name: '${cp_url.split("/")[-1]}'
        publish:
          - folder_path
          - file_path
        navigate:
          - SUCCESS: download_cp
    - import_and_assign_cp:
        do:
          rpa.designer.rest.content-pack.import_and_assign_cp:
            - token: '${token}'
            - cp_file: '${file_path}'
            - ws_id: '${ws_id}'
        publish:
          - status_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_temp_folder
    - is_temp_folder:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(folder_path) > 0)}'
        navigate:
          - 'TRUE': delete
          - 'FALSE': SUCCESS
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${folder_path}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - on_failure:
        - delete_on_failure:
            do:
              io.cloudslang.base.filesystem.delete:
                - source: '${folder_path}'
  outputs:
    - status_json: '${status_json}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      file_path_given:
        x: 71
        'y': 97
      delete:
        x: 499
        'y': 97
        navigate:
          7714f1ec-5857-9e75-199a-0e3bdd3afe85:
            targetId: 86756514-aadf-066b-11e9-81a94bded20b
            port: SUCCESS
      get_temp_file:
        x: 310
        'y': 97
      import_and_assign_cp:
        x: 293
        'y': 329
      is_temp_folder:
        x: 500
        'y': 328
        navigate:
          43bb3a6e-a03e-ef93-b7ce-60d90cc9a90d:
            targetId: 86756514-aadf-066b-11e9-81a94bded20b
            port: 'FALSE'
      download_cp:
        x: 73
        'y': 328
    results:
      SUCCESS:
        86756514-aadf-066b-11e9-81a94bded20b:
          x: 683
          'y': 99
