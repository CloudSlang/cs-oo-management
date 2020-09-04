########################################################################################################################
#!!
#! @description: Gets the representation (group rule) json.
#!
#! @input org_id: Organization ID the representation belongs to.
#! @input group_id: The group ID the representation belongs to.
#! @input repre_name: Representation name
#!
#! @output repre_json: Json with the representation details
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.representation
flow:
  name: get_representation
  inputs:
    - token
    - org_id
    - group_id
    - repre_name
  workflow:
    - get_representations:
        do:
          io.cloudslang.microfocus.rpa.idm.representation.get_representations:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_id: '${group_id}'
        publish:
          - repres_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${repres_json}'
            - json_path: "${\"$.[?(@.name == '%s')]\" % repre_name}"
        publish:
          - repre_json: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - repre_json: '${repre_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_representations:
        x: 65
        'y': 116
      json_path_query:
        x: 221
        'y': 116
        navigate:
          fa893f72-24cd-77da-7f39-7113bd303c24:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 379
          'y': 123
