########################################################################################################################
#!!
#! @description: Uploads (rewrites) the existing project file with a new content.
#!
#! @input file_id: ID of the file to be rewritten
#! @input file_path: File to be uploaded
#!
#! @output file_content: New file content that has been uploaded
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.designer.project
flow:
  name: upload_file
  inputs:
    - token
    - file_id
    - file_path
  workflow:
    - read_from_file:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: '${file_path}'
        publish:
          - file_content: '${read_text}'
        navigate:
          - SUCCESS: designer_http_action
          - FAILURE: on_failure
    - designer_http_action:
        do:
          io.cloudslang.microfocus.oo.designer._operations.designer_http_action:
            - url: "${'/rest/v0/elements/%s' % file_id}"
            - token: '${token}'
            - method: PUT
            - body: '${file_content}'
        publish:
          - file_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - file_content: '${file_content}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_from_file:
        x: 44
        'y': 131
      designer_http_action:
        x: 208
        'y': 129
        navigate:
          c26726ec-bf27-1e84-feef-447fdcb62548:
            targetId: 906020c8-7975-21b0-6e0b-0aa6936beecc
            port: SUCCESS
    results:
      SUCCESS:
        906020c8-7975-21b0-6e0b-0aa6936beecc:
          x: 400
          'y': 126
