########################################################################################################################
#!!
#! @description: Gets the group json.
#!
#! @input org_id: Organization ID the group belongs to.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.group
flow:
  name: get_group
  inputs:
    - token
    - org_id
    - group_name
  workflow:
    - get_groups:
        do:
          io.cloudslang.microfocus.rpa.idm.group.get_groups:
            - token: '${token}'
            - org_id: '${org_id}'
        publish:
          - groups_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${groups_json}'
            - json_path: "${\"$.elements[?(@.name == '%s')]\" % group_name}"
        publish:
          - group_json: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - group_json: '${group_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_groups:
        x: 66
        'y': 120
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
