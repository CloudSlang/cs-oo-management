########################################################################################################################
#!!
#! @description: Filters scheduled flows based on a given filter.
#!
#! @input filter_name: Any single filter name like: flowUuid, flowScheduleName, flowPath, flowName, id, enabled, etc.
#! @input filter_value: Value, like: 'io.cloudslang.my_namespace.my_flow', 'my_flow', 'id', true, etc. String values need to be enclosed in quotes.
#!
#! @output schedules_json: List of schedules corresponding with the filter
#! @output schedule_ids: IDs of the filtered schedules
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.central.scheduler
flow:
  name: filter_schedules
  inputs:
    - filter_name
    - filter_value
  workflow:
    - get_schedules:
        do:
          io.cloudslang.microfocus.oo.central.scheduler.get_schedules: []
        publish:
          - schedules_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${schedules_json}'
            - json_path: '${"$.[?(@.%s == %s)]" % (filter_name, filter_value)}'
        publish:
          - schedules_json: '${return_result}'
        navigate:
          - SUCCESS: get_schedule_ids
          - FAILURE: on_failure
    - get_schedule_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${schedules_json}'
            - json_path: '${"$.[?(@.%s == %s)].id" % (filter_name, filter_value)}'
        publish:
          - schedule_ids: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - schedules_json: '${schedules_json}'
    - schedule_ids: '${schedule_ids}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_schedules:
        x: 40
        'y': 77
      json_path_query:
        x: 230
        'y': 79
      get_schedule_ids:
        x: 422
        'y': 79
        navigate:
          94caca0d-767e-6e56-d037-686ffc922a04:
            targetId: 8a12e61f-e5e8-a8ab-d96d-ed1d69d46fe2
            port: SUCCESS
    results:
      SUCCESS:
        8a12e61f-e5e8-a8ab-d96d-ed1d69d46fe2:
          x: 601
          'y': 83
