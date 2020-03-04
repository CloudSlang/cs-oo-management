########################################################################################################################
#!!
#! @description: Schedules all flows under Library/Micro Focus/Misc folder; each with a random number of occurrences (5-50) and a random ROI input parameter (10-1000).
#!!#
########################################################################################################################
namespace: demo
flow:
  name: generate_roi_numbers
  workflow:
    - get_flows:
        do:
          rpa.rest.library.get_flows:
            - path: Library/Micro Focus/Misc
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
            demo.sub_flows.schedule_flow:
              - flows_json: '${flows_json}'
              - flow_uuid: '${flow_id[1:-1]}'
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
