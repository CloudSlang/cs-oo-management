########################################################################################################################
#!!
#! @description: Downloads a file from URL.
#!
#! @input file_url: URL pointing to the file
#! @input file_path: If given, the downloaded file will be placed to this file (otherwise a temporal folder will be created)
#!
#! @output downloaded_file_path: Full path to the downloaded file
#! @output folder_path: Temporal folder (parent of the downloaded_file_path) or empty (if file_path given)
#!!#
########################################################################################################################
namespace: io.cloudslang.base.utils
flow:
  name: download_file
  inputs:
    - file_url
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
          - 'TRUE': http_client_action
          - 'FALSE': get_temp_file
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${file_url}'
            - auth_type: anonymous
            - destination_file: '${file_path}'
            - content_type: application/octet-stream
            - method: GET
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_temp_file:
        do:
          io.cloudslang.base.filesystem.temp.get_temp_file:
            - file_name: '${file_url.split("/")[-1]}'
        publish:
          - folder_path
          - file_path
        navigate:
          - SUCCESS: http_client_action
    - on_failure:
        - delete_on_failure:
            do:
              io.cloudslang.base.filesystem.delete:
                - source: '${folder_path}'
  outputs:
    - downloaded_file_path: '${file_path}'
    - folder_path: '${folder_path}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      file_path_given:
        x: 71
        'y': 97
      http_client_action:
        x: 73
        'y': 328
        navigate:
          2c5c75d7-0394-9e56-5e8a-a3856394cc98:
            targetId: 86756514-aadf-066b-11e9-81a94bded20b
            port: SUCCESS
      get_temp_file:
        x: 310
        'y': 97
    results:
      SUCCESS:
        86756514-aadf-066b-11e9-81a94bded20b:
          x: 316
          'y': 328
