########################################################################################################################
#!!
#! @description: Sets the IDM configuration property.
#!!#
########################################################################################################################
namespace: rpa.idm.rest.configuration
flow:
  name: set_property
  inputs:
    - property_name
    - property_value
  workflow:
    - get_token:
        do:
          rpa.idm.rest.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_action
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s/api/system/configurations/items' % get_sp('idm_url')}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: |-
                ${'''Accept: application/json
                X-Auth-Token: %s
                ''' % token}
            - body: |-
                ${'''{
                  "resourceconfig": [
                   {
                      "name": "%s",
                      "value": "%s"

                   }
                   ]
                }''' % (property_name, property_value)}
            - content_type: application/json
            - method: PATCH
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 101
        'y': 116
      http_client_action:
        x: 283
        'y': 112
        navigate:
          35cecb75-1eb7-4601-a70d-5b6975cfe32b:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 454
          'y': 112
