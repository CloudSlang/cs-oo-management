########################################################################################################################
#!!
#! @description: Schedules all flows under the given folder; each with a random number of occurrences and a random ROI input parameter.
#!
#! @input path: Path to a folder where to take the flows from.
#! @input trigger_expression: How often to trigger the flow. */60000 = every minute;*/3600000 = every hour
#! @input num_of_occurences_range: How many times to schedule; provide a range of min-max value; each flow will be scheduled with a random number of occurrences within the range
#! @input roi_range: Return On Investment for each flow; provide a range of min-max value; each flow will get a random ROI in the range
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: generate_roi_numbers
  inputs:
    - path: Library/Micro Focus/Misc
    - trigger_expression: '*/60000'
    - num_of_occurences_range: 5-50
    - roi_range: 10-100
  workflow:
    - get_flows:
        do:
          io.cloudslang.microfocus.rpa.central.library.get_flows:
            - path: '${path}'
        publish:
          - flows_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_flow_ids
    - get_flow_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flows_json}'
            - json_path: $..id
        publish:
          - flow_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: schedule_flow
          - FAILURE: on_failure
    - schedule_flow:
        loop:
          for: flow_id in flow_ids
          do:
            io.cloudslang.microfocus.rpa.demo.sub_flows.schedule_flow:
              - flows_json: '${flows_json}'
              - flow_uuid: '${flow_id[1:-1]}'
              - trigger_expression: '${trigger_expression}'
              - num_of_occurrences_range: '${num_of_occurences_range}'
              - roi_range: '${roi_range}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_flows:
        x: 69
        'y': 127
      get_flow_ids:
        x: 254
        'y': 130
      schedule_flow:
        x: 435
        'y': 128
        navigate:
          5237850d-dc42-25c8-4a9d-327f9887e8fc:
            targetId: a660a4ba-4ba5-eaca-d30d-e5c3264e7b50
            port: SUCCESS
    results:
      SUCCESS:
        a660a4ba-4ba5-eaca-d30d-e5c3264e7b50:
          x: 634
          'y': 130
