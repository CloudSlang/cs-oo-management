########################################################################################################################
#!!
#! @description: Retrieves the given project file properties including the file content.
#!
#! @input ws_id: ID of the workspace where the file belongs to
#! @input file_id: ID of the file whose properties to be retrieved
#!
#! @output file_json: JSON document describing the file properties
#! @output file_content: Content of the file decoded from JSON format
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.project
flow:
  name: get_file
  inputs:
    - ws_id
    - file_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/elements/%s?workspaceId=%s' % (file_id, ws_id)}"
            - method: GET
        publish:
          - file_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${file_json}'
            - json_path: $.element.fileSource
        publish:
          - file_content: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - file_json: '${file_json}'
    - file_content: "${file_content[1:-1].replace('\\\\r\\\\n','\\n').replace('\\\\n','\\n').replace('\\\\\"','\"').replace('\\\\\\\\', '\\\\')}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 43
        'y': 84
      json_path_query:
        x: 197
        'y': 85
        navigate:
          e64cb030-57d5-162a-1e32-a17b7200c238:
            targetId: afbc9a92-9983-593b-05de-ba94c44c2f2a
            port: SUCCESS
    results:
      SUCCESS:
        afbc9a92-9983-593b-05de-ba94c44c2f2a:
          x: 361
          'y': 92
