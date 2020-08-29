########################################################################################################################
#!!
#! @description: Downloads a CP from URL, imports that into Designer and optionally assigns it to a workspace.
#!
#! @input cp_url: URL pointing to a CP
#! @input ws_id: If given, the imported CP will be also assigned to the given WS
#! @input file_path: If given, the downloaded CP will be placed to this file (otherwise temporal will be created and removed later)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack
flow:
  name: import_cp_from_url
  inputs:
    - token
    - cp_url
    - ws_id:
        required: false
    - file_path:
        required: false
  workflow:
    - download_file:
        do:
          io.cloudslang.base.utils.download_file:
            - file_url: '${cp_url}'
            - file_path: '${file_path}'
        publish:
          - downloaded_file_path
          - folder_path
        navigate:
          - SUCCESS: import_cp
          - FAILURE: on_failure
    - import_cp:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.import_cp:
            - token: '${token}'
            - cp_file: '${downloaded_file_path}'
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
        - delete_temp_file:
            do:
              io.cloudslang.base.filesystem.temp.delete_temp_file:
                - folder_path: '${folder_path}'
                - file_path: '${downloaded_file_path}'
  outputs:
    - status_json: '${status_json}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      download_file:
        x: 294
        'y': 93
      import_cp:
        x: 293
        'y': 329
      is_temp_folder:
        x: 500
        'y': 328
        navigate:
          43bb3a6e-a03e-ef93-b7ce-60d90cc9a90d:
            targetId: 86756514-aadf-066b-11e9-81a94bded20b
            port: 'FALSE'
      delete:
        x: 499
        'y': 97
        navigate:
          7714f1ec-5857-9e75-199a-0e3bdd3afe85:
            targetId: 86756514-aadf-066b-11e9-81a94bded20b
            port: SUCCESS
    results:
      SUCCESS:
        86756514-aadf-066b-11e9-81a94bded20b:
          x: 683
          'y': 99
