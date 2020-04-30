namespace: rpa.designer.rest.dependency.sub_flows
flow:
  name: import_file
  inputs:
    - token
    - process_id
  workflow:
    - designer_http_action:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/imports/%s' % process_id}"
            - token: '${token}'
            - method: PUT
            - verify_result: nothing
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 69
        'y': 117
        navigate:
          5e989a74-b680-90cd-10b0-39828aefd5be:
            targetId: f6207fa2-0c4e-a3be-9e3f-60c23aec0b7f
            port: SUCCESS
    results:
      SUCCESS:
        f6207fa2-0c4e-a3be-9e3f-60c23aec0b7f:
          x: 295
          'y': 119
