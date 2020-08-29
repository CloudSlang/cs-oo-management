########################################################################################################################
#!!
#! @description: Deletes the given policy.
#!
#! @input org_id: Organization ID the policy belongs to.
#! @input policy_id: ID of policy to be deleted.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.policy
flow:
  name: delete_policy
  inputs:
    - token
    - org_id
    - policy_id
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: "${'/api/scim/organizations/%s/policies/%s' % (org_id, policy_id)}"
            - token: '${token}'
            - method: DELETE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 78
        'y': 111
        navigate:
          d5f21432-92e0-a471-c19b-7264f8856b2c:
            targetId: dc11c7c7-97c1-c752-a774-abd771eba418
            port: SUCCESS
    results:
      SUCCESS:
        dc11c7c7-97c1-c752-a774-abd771eba418:
          x: 248
          'y': 94
