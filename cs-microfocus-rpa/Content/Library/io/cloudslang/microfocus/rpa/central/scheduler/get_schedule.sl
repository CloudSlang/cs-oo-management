namespace: io.cloudslang.microfocus.rpa.central.scheduler
flow:
  name: get_schedule
  inputs:
    - flow_uuid
  workflow:
    - get_schedules:
        do:
          io.cloudslang.microfocus.rpa.central.scheduler.get_schedules: []
        publish:
          - schedules_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${schedules_json}'
            - json_path: "${\"$.[?(@.flowUuid == '%s')]\" % flow_uuid}"
        publish:
          - schedules_json: '${return_result}'
        navigate:
          - SUCCESS: get_schedule_id
          - FAILURE: on_failure
    - get_schedule_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${schedules_json}'
            - json_path: "${\"$.[?(@.flowUuid == '%s')].id\" % flow_uuid}"
        publish:
          - schedule_id: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - schedules_json: '${schedules_json}'
    - schedules_ids: '${schedule_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_schedules:
        x: 70
        'y': 75
      json_path_query:
        x: 247
        'y': 76
      get_schedule_id:
        x: 469
        'y': 92
        navigate:
          94caca0d-767e-6e56-d037-686ffc922a04:
            targetId: 8a12e61f-e5e8-a8ab-d96d-ed1d69d46fe2
            port: SUCCESS
    results:
      SUCCESS:
        8a12e61f-e5e8-a8ab-d96d-ed1d69d46fe2:
          x: 634
          'y': 90
