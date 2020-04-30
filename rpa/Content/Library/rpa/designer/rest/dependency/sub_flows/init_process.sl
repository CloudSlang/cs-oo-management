namespace: rpa.designer.rest.dependency.sub_flows
flow:
  name: init_process
  inputs:
    - token
  workflow:
    - designer_http_action:
        do:
          rpa.tools.designer_http_action:
            - url: /rest/v0/imports
            - token: '${token}'
            - method: POST
        publish:
          - job_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${job_json}'
            - json_path: $.importProcessId
        publish:
          - process_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - process_id: '${process_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 105
        'y': 134
      json_path_query:
        x: 293
        'y': 140
        navigate:
          6e826542-8d04-ce5b-aeb2-4421b3072e67:
            targetId: dc4b2de2-4350-0822-d7c6-6ed91442fbbe
            port: SUCCESS
    results:
      SUCCESS:
        dc4b2de2-4350-0822-d7c6-6ed91442fbbe:
          x: 476
          'y': 142
