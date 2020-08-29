########################################################################################################################
#!!
#! @description: Gets all representations (group rules) belonging to the group and organization.
#!
#! @input org_id: Organization ID the representations belong to.
#! @input group_id: Group ID the representations belong to.
#!
#! @output repres_json: Json with a list of all representations
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.representation
flow:
  name: get_representations
  inputs:
    - token
    - org_id
    - group_id
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/groups/%s/representations' % (org_id, group_id)}"
            - token: '${token}'
            - method: GET
        publish:
          - repres_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - repres_json: '${repres_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 82
        'y': 110
        navigate:
          88b3973e-dd1f-caec-68af-69c6e62eb0fd:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 263
          'y': 113
