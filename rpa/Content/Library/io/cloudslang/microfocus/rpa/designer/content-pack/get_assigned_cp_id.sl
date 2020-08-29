########################################################################################################################
#!!
#! @description: Retrieves the ID of the given deployed Content Pack assigned to the given Workspace
#!
#! @input cp_name: Content Pack Name
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack
flow:
  name: get_assigned_cp_id
  inputs:
    - ws_id
    - cp_name
  workflow:
    - get_assigned_cps:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.get_assigned_cps:
            - ws_id: '${ws_id}'
        publish:
          - cps_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${\"$[?(@.text == '%s')].id\" % cp_name}"
        publish:
          - cp_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - cp_id: '${cp_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_assigned_cps:
        x: 64
        'y': 102
      json_path_query:
        x: 226
        'y': 94
        navigate:
          dd380262-0ded-3dbe-a7b6-740b889b6cf7:
            targetId: 6fd45005-29fc-7f4b-59ff-5dd04c464998
            port: SUCCESS
    results:
      SUCCESS:
        6fd45005-29fc-7f4b-59ff-5dd04c464998:
          x: 402
          'y': 94
