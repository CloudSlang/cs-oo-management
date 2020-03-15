########################################################################################################################
#!!
#! @description: Get flow executions.
#!!#
########################################################################################################################
namespace: rpa.central.rest.settings
flow:
  name: get_cp_settings
  workflow:
    - central_http_action:
        do:
          rpa.tools.central_http_action:
            - url: /rest/latest/content-pack-settings
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
        x: 90
        'y': 99
        navigate:
          5edf02c6-ae29-10d7-cac2-15de9a10a702:
            targetId: 758cfec6-ce01-09da-81b8-ff6bfe5c6032
            port: SUCCESS
    results:
      SUCCESS:
        758cfec6-ce01-09da-81b8-ff6bfe5c6032:
          x: 263
          'y': 102
