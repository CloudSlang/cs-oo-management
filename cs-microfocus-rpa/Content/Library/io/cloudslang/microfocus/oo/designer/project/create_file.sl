########################################################################################################################
#!!
#! @description: Creates a flow, an operation, a system property or an UI activity. It reads the content of the file from the file_path.
#!
#! @input element_name: Name of the file being created; if not given, the name of the file (without .sl extension) will be used
#! @input folder_id: ID of a folder where this element will be created
#! @input file_path: Content of the file to be created
#!
#! @output result_json: JSON document describing the result of the operation
#! @output element_id: ID of the created file
#! @output element_type: FOLDER, FLOW, PYTHON_OPERATION, SYSTEM_PROPERTY, SEQ_OPERATION
#! @output file_content: Content of the created file (JSON escaped)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.designer.project
flow:
  name: create_file
  inputs:
    - token
    - element_name:
        required: false
    - folder_id
    - file_path:
        required: true
  workflow:
    - read_from_file:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: '${file_path}'
        publish:
          - file_content: '${read_text}'
          - element_type: "${'FLOW' if 'flow:' in file_content else \\\n'SEQ_OPERATION' if 'sequential_action:' in file_content else \\\n'PYTHON_OPERATION' if 'operation:' in file_content else \\\n'SYSTEM_PROPERTY' if 'properties:' in file_content else \\\nNone}"
        navigate:
          - SUCCESS: escape_json
          - FAILURE: on_failure
    - create_element:
        do:
          io.cloudslang.microfocus.oo.designer.project.create_element:
            - token: '${token}'
            - element_name: "${(file_path.split('/')[-1][:-3] if file_path.endswith('.sl') else file_path.split('/')[-1]) if element_name is None else element_name}"
            - element_type: '${element_type}'
            - folder_id: '${folder_id}'
            - file_content: '${file_content}'
        publish:
          - result_json
          - element_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - escape_json:
        do:
          io.cloudslang.base.json.escape_json:
            - input_string: '${file_content}'
        publish:
          - file_content: '${output_string}'
        navigate:
          - SUCCESS: create_element
          - FAILURE: on_failure
  outputs:
    - result_json: '${result_json}'
    - element_id: '${element_id}'
    - element_type: '${element_type}'
    - file_content: '${file_content}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_from_file:
        x: 37
        'y': 76
      create_element:
        x: 383
        'y': 79
        navigate:
          353a3733-ff20-8804-1b30-6dccafefdeba:
            targetId: 40c20c47-b23a-6149-20a4-0dcf3e82069d
            port: SUCCESS
      escape_json:
        x: 214
        'y': 81
    results:
      SUCCESS:
        40c20c47-b23a-6149-20a4-0dcf3e82069d:
          x: 563
          'y': 81
