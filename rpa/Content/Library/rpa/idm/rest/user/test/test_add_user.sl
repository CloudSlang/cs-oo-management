namespace: rpa.idm.rest.user.test
flow:
  name: test_add_user
  inputs:
    - username: salesforcedev
    - password: Cloud@123
  workflow:
    - get_token:
        do:
          rpa.idm.rest.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_organization_id
    - add_user:
        do:
          rpa.idm.rest.user.add_user:
            - token: '${token}'
            - username: '${username}'
            - password: '${password}'
            - org_id: '${org_id}'
        publish:
          - json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_organization_id:
        do:
          rpa.idm.rest.organization.get_organization_id:
            - token: '${token}'
        publish:
          - org_id
        navigate:
          - SUCCESS: add_user
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_user:
        x: 391
        'y': 92
        navigate:
          fd1ec898-a2b1-89eb-a0b2-452f8111849e:
            targetId: 2a70c61f-a4f0-f205-b72e-68c138b90067
            port: SUCCESS
      get_token:
        x: 53
        'y': 91
      get_organization_id:
        x: 224
        'y': 94
    results:
      SUCCESS:
        2a70c61f-a4f0-f205-b72e-68c138b90067:
          x: 544
          'y': 92
