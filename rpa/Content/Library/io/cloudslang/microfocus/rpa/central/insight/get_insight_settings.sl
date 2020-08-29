########################################################################################################################
#!!
#! @description: Gets insight service settings.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.insight
flow:
  name: get_insight_settings
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: /rest/v1/components/insights/advanced-configuration
            - method: GET
        publish:
          - settings_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - settings_json: '${settings_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 96
        'y': 107
        navigate:
          9432ae3a-1b00-0a37-3bbf-aad94f61d9d4:
            targetId: fbd1897e-0737-f6d6-8812-32db925ded57
            port: SUCCESS
    results:
      SUCCESS:
        fbd1897e-0737-f6d6-8812-32db925ded57:
          x: 267
          'y': 102
