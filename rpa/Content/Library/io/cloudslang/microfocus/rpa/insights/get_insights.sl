########################################################################################################################
#!!
#! @description: Gets Insights service details - insights, statuses and flows.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.insights
flow:
  name: get_insights
  workflow:
    - insights_http_action:
        do:
          io.cloudslang.microfocus.rpa.insights._operations.insights_http_action:
            - url: /rest/v0/insights?light=false
            - method: GET
        publish:
          - all_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_insights_json
    - get_insights_json:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${all_json}'
            - json_path: $.insights
        publish:
          - insights_json: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_statuses_json
          - FAILURE: on_failure
    - get_statuses_json:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${all_json}'
            - json_path: $.statuses
        publish:
          - statuses_json: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_flows_json
          - FAILURE: on_failure
    - get_flows_json:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${all_json}'
            - json_path: $.flows
        publish:
          - flows_json: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - insights_json: '${insights_json}'
    - statuses_json: '${statuses_json}'
    - flows_json: '${flows_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      insights_http_action:
        x: 90
        'y': 96
      get_insights_json:
        x: 250
        'y': 97
      get_statuses_json:
        x: 68
        'y': 294
      get_flows_json:
        x: 240
        'y': 293
        navigate:
          d72cfccd-4407-f9aa-145f-00c7d95c611b:
            targetId: 737a6fb6-0b9a-978b-9b20-5c6fe7bc3792
            port: SUCCESS
    results:
      SUCCESS:
        737a6fb6-0b9a-978b-9b20-5c6fe7bc3792:
          x: 420
          'y': 100
