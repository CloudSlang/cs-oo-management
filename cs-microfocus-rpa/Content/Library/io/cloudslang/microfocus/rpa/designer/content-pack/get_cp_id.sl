########################################################################################################################
#!!
#! @description: Retrieves the ID of the given deployed Content Pack
#!
#! @input cp_name: Content Pack Name
#! @input cp_version: Content Pack Version
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack
flow:
  name: get_cp_id
  inputs:
    - cp_name
    - cp_version
  workflow:
    - get_cps:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.get_cps: []
        publish:
          - cps_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${\"$[?(@.version == '%s' && @.name == '%s')].id\" % (cp_version, cp_name)}"
        publish:
          - cp_id: '${return_result[1:-1]}'
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
      get_cps:
        x: 65
        'y': 93
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
