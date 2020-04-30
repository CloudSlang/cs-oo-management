namespace: rpa.designer.rest.dependency.sub_flows
flow:
  name: get_process_status
  inputs:
    - process_id
  workflow:
    - get_process:
        do:
          rpa.designer.rest.dependency.sub_flows.get_process:
            - process_id: '${process_id}'
        publish:
          - process_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${process_json}'
            - json_path: $.status
        publish:
          - process_status: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - process_status: '${process_status}'
    - process_json: '${process_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_process:
        x: 104
        'y': 94
      json_path_query:
        x: 291
        'y': 96
        navigate:
          b6eb997d-2a29-96c9-05e6-0f7aa602cf39:
            targetId: b24b0aa6-9524-5e28-18aa-6a6a115c11e9
            port: SUCCESS
    results:
      SUCCESS:
        b24b0aa6-9524-5e28-18aa-6a6a115c11e9:
          x: 482
          'y': 98
