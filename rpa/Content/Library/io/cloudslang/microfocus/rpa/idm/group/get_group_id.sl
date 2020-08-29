########################################################################################################################
#!!
#! @description: Gets the group ID.
#!
#! @input org_id: Organization ID the group belongs to.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.group
flow:
  name: get_group_id
  inputs:
    - token
    - org_id
    - group_name
  workflow:
    - get_group:
        do:
          io.cloudslang.microfocus.rpa.idm.group.get_group:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_name: '${group_name}'
        publish:
          - group_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${group_json}'
            - json_path: $.id
        publish:
          - group_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - group_id: '${group_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_group:
        x: 82
        'y': 138
      json_path_query:
        x: 239
        'y': 142
        navigate:
          3ba7a6b5-15c3-fb4e-bf25-0ed7b04fc6e6:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 395
          'y': 133
