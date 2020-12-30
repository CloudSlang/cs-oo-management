########################################################################################################################
#!!
#! @description: Uploads project files from the given path to the user workspace (files will be rewritten).
#!               
#!
#! @input projects_details: List of projects with list of flows/operations/properties
#! @input folder_path: Root folder of the project files
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.project
flow:
  name: upload_project_files
  inputs:
    - token
    - projects_details
    - folder_path
    - flows:
        default: "${str(eval(projects_details)[0].get('flows'))}"
        private: true
    - operations:
        default: "${str(eval(projects_details)[0].get('operations'))}"
        private: true
    - properties:
        default: "${str(eval(projects_details)[0].get('properties'))}"
        private: true
  workflow:
    - has_flows:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(flows)) > 0)}'
        navigate:
          - 'TRUE': upload_flow
          - 'FALSE': has_operations
    - upload_flow:
        loop:
          for: flow in eval(flows)
          do:
            io.cloudslang.microfocus.rpa.designer.project.upload_file:
              - token: '${token}'
              - file_id: "${str(flow.get('id'))}"
              - file_path: "${folder_path+'/'+flow.get('path')}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: has_operations
    - has_operations:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(operations)) > 0)}'
        navigate:
          - 'TRUE': upload_operation
          - 'FALSE': has_properties
    - has_properties:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(properties)) > 0)}'
        navigate:
          - 'TRUE': upload_property
          - 'FALSE': SUCCESS
    - upload_operation:
        loop:
          for: operation in eval(operations)
          do:
            io.cloudslang.microfocus.rpa.designer.project.upload_file:
              - token: '${token}'
              - file_id: "${str(operation.get('id'))}"
              - file_path: "${folder_path+'/'+operation.get('path')}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: has_properties
    - upload_property:
        loop:
          for: property in eval(properties)
          do:
            io.cloudslang.microfocus.rpa.designer.project.upload_file:
              - token: '${token}'
              - file_id: "${str(property.get('id'))}"
              - file_path: "${folder_path+'/'+property.get('path')}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      upload_operation:
        x: 294
        'y': 373
      has_flows:
        x: 75
        'y': 123
      has_operations:
        x: 291
        'y': 120
      has_properties:
        x: 489
        'y': 118
        navigate:
          31aa8094-dcdb-36fa-9536-238f0b8a2f24:
            targetId: 1e279119-636f-7367-c9ab-cb2258262002
            port: 'FALSE'
      upload_flow:
        x: 76
        'y': 373
      upload_property:
        x: 489
        'y': 373
        navigate:
          a58dd00b-12cb-2b99-e1d4-42e6ab0b0c86:
            targetId: 1e279119-636f-7367-c9ab-cb2258262002
            port: SUCCESS
    results:
      SUCCESS:
        1e279119-636f-7367-c9ab-cb2258262002:
          x: 725
          'y': 118
