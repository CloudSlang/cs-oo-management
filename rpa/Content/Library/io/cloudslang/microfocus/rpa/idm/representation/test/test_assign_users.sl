namespace: io.cloudslang.microfocus.rpa.idm.representation.test
flow:
  name: test_assign_users
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
          - SUCCESS: assign_users
          - FAILURE: on_failure
    - assign_users:
        do:
          io.cloudslang.microfocus.rpa.idm.representation.assign_users:
            - token: '${token}'
            - org_id: '${org_id}'
            - group_id: '${group_id}'
            - repre_name: OO_AGR_ADMINISTRATOR
            - new_user_ids: '["2c906fdc71742479017174acd1b40020","2c906fdc71742479017175b0fdc20077","2c906fdc717424790171747eefa6000d"]'
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
      get_organization_id:
        x: 213
        'y': 128
      get_group_id:
        x: 389
        'y': 135
      assign_users:
        x: 76
        'y': 312
        navigate:
          2471b7b8-bf0f-eb71-8eae-47031ccac0ac:
            targetId: 7801c5bc-6b77-36c8-95ed-3e087a1a524b
            port: SUCCESS
    results:
      SUCCESS:
        7801c5bc-6b77-36c8-95ed-3e087a1a524b:
          x: 384
          'y': 310
