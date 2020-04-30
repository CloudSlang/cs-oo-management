namespace: rpa.designer.rest.dependency.sub_flows
flow:
  name: get_process
  inputs:
    - process_id
  workflow:
    - designer_http_action:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/imports/%s' % process_id}"
            - method: GET
        publish:
          - process_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - process_json: '${process_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 97
        'y': 101
        navigate:
          8dcbdcf9-3aab-03e8-c8db-fd7e93211b8c:
            targetId: e07734c2-c91c-6b69-f1a8-6144bc385b01
            port: SUCCESS
    results:
      SUCCESS:
        e07734c2-c91c-6b69-f1a8-6144bc385b01:
          x: 288
          'y': 101
