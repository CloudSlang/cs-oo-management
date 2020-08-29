namespace: io.cloudslang.microfocus.rpa.demo.sub_flows
flow:
  name: schedule_flow
  inputs:
    - flows_json
    - flow_uuid
    - trigger_expression
    - num_of_occurrences_range
    - roi_range
  workflow:
    - get_flow_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flows_json}'
            - json_path: "${'$[?(@.id==\"%s\")].name' % flow_uuid}"
        publish:
          - flow_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_random_roi
          - FAILURE: on_failure
    - get_random_roi:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: "${roi_range.split('-')[0]}"
            - max: "${roi_range.split('-')[1]}"
        publish:
          - roi: '${random_number}'
        navigate:
          - SUCCESS: get_random_occurences
          - FAILURE: on_failure
    - schedule_flow:
        do:
          io.cloudslang.microfocus.rpa.central.scheduler.schedule_flow:
            - name: '${flow_name}'
            - uuid: '${flow_uuid}'
            - trigger_expression: '${trigger_expression}'
            - start_date: '${date}'
            - inputs: "${'\"count\": \"%s\"' % roi}"
            - time_zone: Etc/GMT
            - num_of_occurences: '${num_of_occurences}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_random_occurences:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: "${num_of_occurrences_range.split('-')[0]}"
            - max: "${num_of_occurrences_range.split('-')[1]}"
        publish:
          - num_of_occurences: '${random_number}'
        navigate:
          - SUCCESS: get_time
          - FAILURE: on_failure
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - date_format: "${'''yyyy-MM-dd'T'hh:mm:ss'''}"
        publish:
          - date: '${output}'
        navigate:
          - SUCCESS: schedule_flow
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_flow_name:
        x: 49
        'y': 102
      get_random_roi:
        x: 215
        'y': 104
      schedule_flow:
        x: 221
        'y': 277
        navigate:
          05455070-7bec-581c-f76b-67db96bca3c3:
            targetId: 53907060-cec6-b5bd-1d79-ae7c7ef26bfb
            port: SUCCESS
      get_random_occurences:
        x: 376
        'y': 109
      get_time:
        x: 42
        'y': 275
    results:
      SUCCESS:
        53907060-cec6-b5bd-1d79-ae7c7ef26bfb:
          x: 381
          'y': 274
