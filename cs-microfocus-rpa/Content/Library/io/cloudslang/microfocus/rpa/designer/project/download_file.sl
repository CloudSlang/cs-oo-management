########################################################################################################################
#!!
#! @description: Downloads the given project file to the specified path.
#!
#! @input ws_id: ID of the workspace where the file belongs to
#! @input file_id: ID of the file to be downloaded
#! @input file_path: Path where to download the file
#!
#! @output file_json: JSON document describing the file properties
#! @output file_content: Content of the file decoded from JSON format
#! @output failure: Message in case of a failure
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.project
flow:
  name: download_file
  inputs:
    - ws_id
    - file_id
    - file_path
  workflow:
    - get_file:
        do:
          io.cloudslang.microfocus.rpa.designer.project.get_file:
            - ws_id: '${ws_id}'
            - file_id: '${file_id}'
        publish:
          - file_json
          - file_content
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_to_file
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: '${file_path}'
            - text: '${file_content}'
            - encode_type: utf_8
        publish:
          - message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - file_json: '${file_json}'
    - file_content: '${file_content}'
    - failure: '${message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_file:
        x: 43
        'y': 117
      write_to_file:
        x: 219
        'y': 120
        navigate:
          87cadd81-f505-598d-8de4-c89adc3bdf75:
            targetId: 906020c8-7975-21b0-6e0b-0aa6936beecc
            port: SUCCESS
    results:
      SUCCESS:
        906020c8-7975-21b0-6e0b-0aa6936beecc:
          x: 404
          'y': 120
