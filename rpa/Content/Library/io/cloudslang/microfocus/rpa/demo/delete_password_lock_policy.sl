########################################################################################################################
#!!
#! @description: Deletes the password lock policy that is assigned for idm_tenant organization (if any). It fails if there is no such policy.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: delete_password_lock_policy
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_organization_id
    - get_organization_id:
        do:
          io.cloudslang.microfocus.rpa.idm.organization.get_organization_id:
            - token: '${token}'
            - org_name: "${get_sp('io.cloudslang.microfocus.rpa.idm_tenant')}"
        publish:
          - org_id
        navigate:
          - SUCCESS: get_policy_id
          - FAILURE: on_failure
    - get_policy_id:
        do:
          io.cloudslang.microfocus.rpa.idm.policy.get_policy_id:
            - token: '${token}'
            - org_id: '${org_id}'
        publish:
          - policy_id
        navigate:
          - SUCCESS: delete_policy
          - FAILURE: on_failure
    - delete_policy:
        do:
          io.cloudslang.microfocus.rpa.idm.policy.delete_policy:
            - token: '${token}'
            - org_id: '${org_id}'
            - policy_id: '${policy_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 50
        'y': 125
      get_organization_id:
        x: 221
        'y': 128
      get_policy_id:
        x: 396
        'y': 131
      delete_policy:
        x: 550
        'y': 134
        navigate:
          df0fd780-9ae2-e6b4-4c88-785506fdaf89:
            targetId: 68ebeb0e-7298-3165-8584-c45b44d4263f
            port: SUCCESS
    results:
      SUCCESS:
        68ebeb0e-7298-3165-8584-c45b44d4263f:
          x: 710
          'y': 119
