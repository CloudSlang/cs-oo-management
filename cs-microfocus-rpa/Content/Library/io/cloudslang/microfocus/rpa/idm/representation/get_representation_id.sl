########################################################################################################################
#!!
#! @description: Gets the representation (group rule) ID.
#!
#! @input org_id: Organization ID the representation belongs to.
#! @input group_id: Group ID the representation belongs to.
#! @input repre_name: Representation name
#!
#! @output repre_id: ID od the representation
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.representation
flow:
  name: get_representation_id
  inputs:
    - token
    - org_id
    - group_id
    - repre_name
  workflow:
    - get_representation:
        do:
          io.cloudslang.microfocus.rpa.idm.representation.get_representation:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_id: '${group_id}'
            - repre_name: '${repre_name}'
        publish:
          - repre_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${repre_json}'
            - json_path: $.id
        publish:
          - repre_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - repre_id: '${repre_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_representation:
        x: 58
        'y': 118
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
