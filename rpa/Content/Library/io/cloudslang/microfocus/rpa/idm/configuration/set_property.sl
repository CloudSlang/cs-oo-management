########################################################################################################################
#!!
#! @description: Sets the IDM configuration property.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.configuration
flow:
  name: set_property
  inputs:
    - token
    - property_name
    - property_value
  workflow:
    - idm_http_action:
        do:
          io.cloudslang.microfocus.rpa.idm._operations.idm_http_action:
            - url: /api/system/configurations/items
            - token: '${token}'
            - method: PATCH
            - body: |-
                ${'''{
                  "resourceconfig": [
                   {
                      "name": "%s",
                      "value": "%s"

                   }
                   ]
                }''' % (property_name, property_value)}
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      idm_http_action:
        x: 82
        'y': 110
        navigate:
          88b3973e-dd1f-caec-68af-69c6e62eb0fd:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 263
          'y': 113
