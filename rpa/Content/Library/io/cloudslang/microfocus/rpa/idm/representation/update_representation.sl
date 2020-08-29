########################################################################################################################
#!!
#! @description: Updates the representation (group rule) using the provided json.
#!
#! @input org_id: Organization ID the representation belongs to.
#! @input group_id: Group ID the representation belongs to.
#! @input repre_id: Representation ID
#! @input repre_json: New content of the representation
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.representation
flow:
  name: update_representation
  inputs:
    - token
    - org_id
    - group_id
    - repre_id
    - repre_json
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/groups/%s/representations/%s' % (org_id, group_id, repre_id)}"
            - token: '${token}'
            - method: PUT
            - body: '${repre_json}'
        publish:
          - new_repre_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - new_repre_json: '${new_repre_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 71
        'y': 121
        navigate:
          98f52255-d16c-11eb-1459-0e11f419d022:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 266
          'y': 118
