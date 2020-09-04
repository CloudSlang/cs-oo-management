########################################################################################################################
#!!
#! @description: Sets general settings.
#!
#! @input settings: List of settings to be changed
#! @input values: List of value of changed settings
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.settings
flow:
  name: set_general_settings
  inputs:
    - settings
    - values
  workflow:
    - get_general_settings:
        do:
          io.cloudslang.microfocus.rpa.central.settings.get_general_settings: []
        publish:
          - settings_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_json_properties
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: /rest/latest/general-settings
            - method: PUT
            - body: '${new_settings_json}'
        publish:
          - settings_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - set_json_properties:
        do:
          io.cloudslang.base.json.set_json_properties:
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
      get_general_settings:
        x: 65
        'y': 89
      central_http_action:
        x: 408
        'y': 90
        navigate:
          5edf02c6-ae29-10d7-cac2-15de9a10a702:
            targetId: 758cfec6-ce01-09da-81b8-ff6bfe5c6032
            port: SUCCESS
      set_json_properties:
        x: 245
        'y': 87
    results:
      SUCCESS:
        758cfec6-ce01-09da-81b8-ff6bfe5c6032:
          x: 580
          'y': 99
