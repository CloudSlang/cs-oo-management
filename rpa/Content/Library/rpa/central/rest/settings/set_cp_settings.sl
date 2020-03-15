########################################################################################################################
#!!
#! @description: Get flow executions.
#!!#
########################################################################################################################
namespace: rpa.central.rest.settings
flow:
  name: set_cp_settings
  inputs:
    - settings: 'cpStatisticsJobEnabled,cpExport'
    - values: 'true,true'
  workflow:
    - get_cp_settings:
        do:
          rpa.central.rest.settings.get_cp_settings: []
        publish:
          - settings_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_json_properties
    - central_http_action:
        do:
          rpa.tools.central_http_action:
            - url: /rest/latest/content-pack-settings
            - method: PUT
            - body: '${new_settings_json}'
        publish:
          - settings_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - set_json_properties:
        do:
          rpa.tools.set_json_properties:
            - json_string: '${settings_json}'
            - properties: '${settings}'
            - values: '${values}'
        publish:
          - new_settings_json: '${result_json}'
        navigate:
          - SUCCESS: central_http_action
  outputs:
    - settings_json: '${settings_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_json_properties:
        x: 245
        'y': 87
      central_http_action:
        x: 408
        'y': 90
        navigate:
          5edf02c6-ae29-10d7-cac2-15de9a10a702:
            targetId: 758cfec6-ce01-09da-81b8-ff6bfe5c6032
            port: SUCCESS
      get_cp_settings:
        x: 79
        'y': 92
    results:
      SUCCESS:
        758cfec6-ce01-09da-81b8-ff6bfe5c6032:
          x: 580
          'y': 99
