########################################################################################################################
#!!
#! @description: Updates the content pack (based on the CP name in the given file) in Central if different than the one already deployed in Central.
#!
#! @input cp_file: The content pack to be imported
#!
#! @output status_json: File upload status
#! @output process_json: Last process status
#! @output process_status: FINISHED if imported fine
#! @output cp_name: Content pack name
#! @output cp_version: Version which got deployed from the file
#! @output original_cp_version: Version of the orginally deployed CP
#! @output updated: true/false if the CP got deployed (updated) or not
#!
#! @result FAILURE: Failure when deploying the CP
#! @result SUCCESS: The CP got deployed successfully
#! @result ALREADY_DEPLOYED: The found CP has been already deployed
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.central.content-pack
flow:
  name: update_cp
  inputs:
    - cp_file
  workflow:
    - get_cp_properties:
        do:
          io.cloudslang.microfocus.base.utils.get_cp_properties:
            - cp_file: '${cp_file}'
        publish:
          - file_cp_version: '${cp_version}'
          - cp_name
        navigate:
          - SUCCESS: get_cp
    - get_cp:
        do:
          io.cloudslang.microfocus.oo.central.content-pack.get_cp:
            - cp_name: '${cp_name}'
        publish:
          - deployed_cp_version: '${cp_version}'
        navigate:
          - FAILURE: import_cp
          - SUCCESS: string_equals
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${file_cp_version}'
            - second_string: '${deployed_cp_version}'
        publish:
          - updated: 'false'
        navigate:
          - SUCCESS: ALREADY_DEPLOYED
          - FAILURE: import_cp
    - import_cp:
        do:
          io.cloudslang.microfocus.oo.central.content-pack.import_cp:
            - cp_file: '${cp_file}'
        publish:
          - status_json
          - process_json
          - process_status
          - updated: 'true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - status_json: '${status_json}'
    - process_json: '${process_json}'
    - process_status: '${process_status}'
    - cp_name: '${cp_name}'
    - cp_version: '${file_cp_version}'
    - original_cp_version: '${deployed_cp_version}'
    - updated: '${updated}'
  results:
    - FAILURE
    - SUCCESS
    - ALREADY_DEPLOYED
extensions:
  graph:
    steps:
      get_cp_properties:
        x: 86
        'y': 83
      get_cp:
        x: 87
        'y': 331
      string_equals:
        x: 327
        'y': 330
        navigate:
          ceffb36b-f45a-42a5-b57a-14171d9e59e5:
            targetId: 4cf25279-ab6a-7bc9-e0d7-3e09467c9931
            port: SUCCESS
      import_cp:
        x: 327
        'y': 77
        navigate:
          4a63bf98-31db-4891-767d-2ad4f614fa85:
            targetId: 1322fd4a-a9cf-d352-6356-9c10e58ada8d
            port: SUCCESS
    results:
      SUCCESS:
        1322fd4a-a9cf-d352-6356-9c10e58ada8d:
          x: 558
          'y': 77
      ALREADY_DEPLOYED:
        4cf25279-ab6a-7bc9-e0d7-3e09467c9931:
          x: 560
          'y': 331
