namespace: io.cloudslang.microfocus.rpa.idm.representation.test
flow:
  name: test_get_assigned_users
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
        publish:
          - org_id
        navigate:
          - SUCCESS: get_group_id
          - FAILURE: on_failure
    - get_group_id:
        do:
          io.cloudslang.microfocus.rpa.idm.group.get_group_id:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_name: ADMINISTRATOR
        publish:
          - group_id
        navigate:
          - SUCCESS: get_assigned_users
          - FAILURE: on_failure
    - get_assigned_users:
        do:
          io.cloudslang.microfocus.rpa.idm.representation.get_assigned_users:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_id: '${group_id}'
            - repre_name: OO_AGR_ADMINISTRATOR
        publish:
          - repre_id
          - user_ids
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
        x: 41
        'y': 133
      get_assigned_users:
        x: 57
        'y': 319
        navigate:
          302f04a6-dd81-c191-8ca4-b722fc1eea39:
            targetId: 7801c5bc-6b77-36c8-95ed-3e087a1a524b
            port: SUCCESS
      get_organization_id:
        x: 214
        'y': 128
      get_group_id:
        x: 389
        'y': 135
    results:
      SUCCESS:
        7801c5bc-6b77-36c8-95ed-3e087a1a524b:
          x: 384
          'y': 310
