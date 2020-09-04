########################################################################################################################
#!!
#! @description: Gets the list of users assigned to the representation.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.representation
flow:
  name: get_assigned_users
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
          - SUCCESS: get_repre_id
    - get_repre_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${repre_json}'
            - json_path: $.id
        publish:
          - repre_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_user_ids
          - FAILURE: on_failure
    - get_user_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${repre_json}'
            - json_path: '$.abstractUsers.*.id'
        publish:
          - user_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - repre_id: '${repre_id}'
    - user_ids: '${user_ids}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_representation:
        x: 91
        'y': 118
      get_repre_id:
        x: 265
        'y': 117
      get_user_ids:
        x: 418
        'y': 115
        navigate:
          d305a682-604e-0d4d-7268-f407f7264e34:
            targetId: 3caccbbc-55a0-a9ed-4dc2-e684cca7e39a
            port: SUCCESS
    results:
      SUCCESS:
        3caccbbc-55a0-a9ed-4dc2-e684cca7e39a:
          x: 589
          'y': 118
