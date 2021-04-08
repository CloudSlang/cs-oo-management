########################################################################################################################
#!!
#! @description: Receives content pack details based on the CP name. It returns empty cp_id and cp_version if no CP with the given name found.
#!
#! @input cp_name: CP name to be found
#!
#! @output cp_json: [] if no CP found
#! @output cp_id: Empty if no CP found
#! @output cp_version: Empty if no CP found
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.central.content-pack
flow:
  name: get_cp
  inputs:
    - cp_name
  workflow:
    - get_cps:
        do:
          io.cloudslang.microfocus.oo.central.content-pack.get_cps: []
        publish:
          - cps_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${\"$[?(@.name == '%s')]\" % cp_name}"
        publish:
          - cp_json: '${return_result}'
          - cp_pton: '${return_result.replace(":null",":None").replace(":true",":True").replace(":false",":False")}'
          - cp_version: "${'' if cp_pton == '[]' else eval(cp_pton)[0]['version']}"
          - cp_id: "${'' if cp_pton == '[]' else eval(cp_pton)[0]['id']}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - cp_json: '${cp_json}'
    - cp_id: '${cp_id}'
    - cp_version: '${cp_version}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_cps:
        x: 87
        'y': 124
      json_path_query:
        x: 291
        'y': 121
        navigate:
          0cd3767b-b645-8bc2-4594-d8d9316eaf12:
            targetId: a7c5620c-e86b-40fd-7ae4-d33c4d5164df
            port: SUCCESS
    results:
      SUCCESS:
        a7c5620c-e86b-40fd-7ae4-d33c4d5164df:
          x: 479
          'y': 116
