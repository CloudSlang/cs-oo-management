########################################################################################################################
#!!
#! @description: Assigns given users to the representation of the given group and organization while keeping also the originally assigned users.
#!
#! @input org_id: ID of the group organization
#! @input group_id: ID of the representation group
#! @input repre_name: Representation where to assign new users
#! @input new_user_ids: IDs of users to be added
#!
#! @output repre_json: JSON document describing the new representation
#! @output repre_id: The representation ID
#! @output original_user_ids: The originally assigned users to the representation before executing this flow.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.representation
flow:
  name: assign_users
  inputs:
    - token
    - org_id
    - group_id
    - repre_name
    - new_user_ids
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
          - SUCCESS: get_existing_user_ids
          - FAILURE: on_failure
    - update_representation:
        do:
          io.cloudslang.microfocus.rpa.idm.representation.update_representation:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_id: '${group_id}'
            - repre_id: '${repre_id}'
            - repre_json: '${new_repre_json}'
        publish:
          - new_repre_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_existing_user_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${repre_json}'
            - json_path: '$.abstractUsers.*.id'
        publish:
          - existing_user_ids: '${return_result}'
        navigate:
          - SUCCESS: set_json_properties
          - FAILURE: on_failure
    - set_json_properties:
        do:
          io.cloudslang.base.json.set_json_properties:
            - json_string: '${repre_json}'
            - properties: users
            - values: '${str(list(eval(existing_user_ids)+eval(new_user_ids)))}'
            - delimiter: '|'
            - evaluate: 'true'
        publish:
          - new_repre_json: '${result_json}'
        navigate:
          - SUCCESS: update_representation
  outputs:
    - repre_json: '${new_repre_json}'
    - repre_id: '${repre_id}'
    - original_user_ids: '${existing_user_ids}'
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
      update_representation:
        x: 328
        'y': 315
        navigate:
          3364daf5-41bb-6467-148c-1321bc8a2649:
            targetId: 3caccbbc-55a0-a9ed-4dc2-e684cca7e39a
            port: SUCCESS
      get_existing_user_ids:
        x: 424
        'y': 117
      set_json_properties:
        x: 84
        'y': 321
    results:
      SUCCESS:
        3caccbbc-55a0-a9ed-4dc2-e684cca7e39a:
          x: 589
          'y': 118
