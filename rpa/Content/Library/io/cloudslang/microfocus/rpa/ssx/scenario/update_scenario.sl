########################################################################################################################
#!!
#! @description: Updates an existing SSX scenario. 
#!
#! @input id: ID of a scenario to be updated
#! @input category_id: Under which category to place the scenario
#! @input scenario_json: JSON doc fully describing the scenario (including all flow inputs). On category ID, %s needs to be placed.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.ssx.scenario
flow:
  name: update_scenario
  inputs:
    - token
    - id
    - category_id
    - scenario_json
  workflow:
    - ssx_http_action:
        do:
          io.cloudslang.microfocus.rpa.ssx._operations.ssx_http_action:
            - url: "${'/rest/v0/scenarios/%s' % id}"
            - token: '${token}'
            - method: PUT
            - body: '${scenario_json % category_id}'
        publish:
          - scenario_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssx_http_action:
        x: 77
        'y': 129
        navigate:
          51b1b8e2-5c44-e317-28fe-06eb996abbea:
            targetId: 95dfb3ec-a5cd-6574-d06a-da1e85b158de
            port: SUCCESS
    results:
      SUCCESS:
        95dfb3ec-a5cd-6574-d06a-da1e85b158de:
          x: 274
          'y': 128
