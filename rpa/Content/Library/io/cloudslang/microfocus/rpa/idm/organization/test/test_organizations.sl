namespace: io.cloudslang.microfocus.rpa.idm.organization.test
flow:
  name: test_organizations
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_organizations
    - get_organizations:
        do:
          io.cloudslang.microfocus.rpa.idm.organization.get_organizations:
            - token: '${token}'
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
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 74
        'y': 90
      get_organizations:
        x: 233
        'y': 87
      get_organization_id:
        x: 388
        'y': 92
        navigate:
          54979fbc-d850-7190-8ed4-aa566756fccc:
            targetId: 137920c8-4c1e-0ec9-bbe0-bbd096c091b1
            port: SUCCESS
    results:
      SUCCESS:
        137920c8-4c1e-0ec9-bbe0-bbd096c091b1:
          x: 539
          'y': 85
