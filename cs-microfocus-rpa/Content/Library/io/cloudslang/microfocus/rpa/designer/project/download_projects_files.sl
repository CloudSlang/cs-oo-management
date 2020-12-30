########################################################################################################################
#!!
#! @description: Downloads all files in the given workspace (belonging to the very first project) to the given folder.
#!               
#!
#! @input ws_id: Workspace to be downloaded
#! @input folder_path: Path where will be the files saved
#!
#! @output projects_details: List of projects with a list of flows/operations/properties the project consists of (as files)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.project
flow:
  name: download_projects_files
  inputs:
    - ws_id
    - folder_path
  workflow:
    - get_projects:
        do:
          io.cloudslang.microfocus.rpa.designer.project.get_projects:
            - ws_id: '${ws_id}'
        publish:
          - projects_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_projects_details
    - create_folder_tree:
        loop:
          for: folder in folders
          do:
            io.cloudslang.base.filesystem.create_folder_tree:
              - folder_name: "${folder_path+'/'+folder}"
          break:
            - FAILURE
        navigate:
          - SUCCESS: has_flows
          - FAILURE: on_failure
    - download_flow:
        loop:
          for: flow in eval(flows)
          do:
            io.cloudslang.microfocus.rpa.designer.project.download_file:
              - ws_id: '${ws_id}'
              - file_id: "${str(flow.get('id'))}"
              - file_path: "${folder_path+'/'+flow.get('path')}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: has_operations
    - download_operation:
        loop:
          for: operation in eval(operations)
          do:
            io.cloudslang.microfocus.rpa.designer.project.download_file:
              - ws_id: '${ws_id}'
              - file_id: "${str(operation.get('id'))}"
              - file_path: "${folder_path+'/'+operation.get('path')}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: has_properties
    - download_properties:
        loop:
          for: property in eval(properties)
          do:
            io.cloudslang.microfocus.rpa.designer.project.download_file:
              - ws_id: '${ws_id}'
              - file_id: "${str(property.get('id'))}"
              - file_path: "${folder_path+'/'+property.get('path')}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - has_flows:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(flows)) > 0)}'
        navigate:
          - 'TRUE': download_flow
          - 'FALSE': has_operations
    - has_properties:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(properties)) > 0)}'
        navigate:
          - 'TRUE': download_properties
          - 'FALSE': SUCCESS
    - has_operations:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(operations)) > 0)}'
        navigate:
          - 'TRUE': download_operation
          - 'FALSE': has_properties
    - get_projects_details:
        do:
          io.cloudslang.microfocus.rpa.designer.project.get_projects_details:
            - projects_json: '${projects_json}'
        publish:
          - projects_details
          - folders: "${','.join(eval(projects_details)[0].get('folders'))}"
          - flows: "${str(eval(projects_details)[0].get('flows'))}"
          - operations: "${str(eval(projects_details)[0].get('operations'))}"
          - properties: "${str(eval(projects_details)[0].get('properties'))}"
        navigate:
          - SUCCESS: create_folder_tree
          - FAILURE: on_failure
  outputs:
    - projects_details: '${projects_details}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      has_flows:
        x: 58
        'y': 278
      get_projects:
        x: 70
        'y': 103
      download_flow:
        x: 59
        'y': 455
      get_projects_details:
        x: 279
        'y': 105
      download_properties:
        x: 467
        'y': 455
        navigate:
          99c1060b-665a-8350-ca70-7aa6351e52ae:
            targetId: b4dcc687-7981-f39a-78ce-69fc2d360fff
            port: SUCCESS
      create_folder_tree:
        x: 467
        'y': 103
      download_operation:
        x: 272
        'y': 454
      has_operations:
        x: 274
        'y': 277
      has_properties:
        x: 468
        'y': 274
        navigate:
          20d68f17-6cae-4e18-a755-f1499777ca82:
            targetId: b4dcc687-7981-f39a-78ce-69fc2d360fff
            port: 'FALSE'
    results:
      SUCCESS:
        b4dcc687-7981-f39a-78ce-69fc2d360fff:
          x: 669
          'y': 274
