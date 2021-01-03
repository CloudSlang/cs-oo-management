########################################################################################################################
#!!
#! @description: Creates a folder or a file with a flow, an operation, a system property or an UI activity.
#!
#! @input element_name: Name of the element being created
#! @input element_type: FOLDER, FLOW, PYTHON_OPERATION, SYSTEM_PROPERTY, SEQ_OPERATION
#! @input folder_id: ID of a folder where this element will be created (parent folder)
#! @input file_content: Not required in case of FOLDER; required otherwise
#!
#! @output result_json: JSON document describing the result of the operation
#! @output element_id: ID of the created element (folder or file)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.project
flow:
  name: create_element
  inputs:
    - token
    - element_name
    - element_type
    - folder_id
    - file_content:
        required: false
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: /rest/v0/elements
            - token: '${token}'
            - method: POST
            - body: |-
                ${'''
                {
                  "text": "%s",
                  "type": "%s",
                  "parentId": "%s",
                  "language": "CloudSlang",
                  "fileSource": %s
                }''' % (element_name, element_type, folder_id, 'null' if file_content is None else '"'+file_content+'"')}
        publish:
          - result_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - result_json: '${result_json}'
    - element_id: "${eval(result_json.replace(':null',':None').replace(':true',':True').replace(':false',':False')).get('id')}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 38
        'y': 73
        navigate:
          44ca4e7b-d9d4-5094-02b1-615d3992fe7d:
            targetId: 40c20c47-b23a-6149-20a4-0dcf3e82069d
            port: SUCCESS
    results:
      SUCCESS:
        40c20c47-b23a-6149-20a4-0dcf3e82069d:
          x: 261
          'y': 72
