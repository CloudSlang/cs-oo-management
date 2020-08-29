########################################################################################################################
#!!
#! @description: Sets the IDM configuration property.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm._operations
flow:
  name: idm_http_action
  inputs:
    - url
    - token
    - method
    - body:
        required: false
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s%s' % (get_sp('io.cloudslang.microfocus.rpa.idm_url'), url)}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: |-
                ${'''Accept: application/json
                X-Auth-Token: %s
                ''' % token}
            - body: '${body}'
            - content_type: application/json
            - method: '${method}'
        publish:
          - return_result
          - error_message
          - response_headers
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 78
        'y': 108
        navigate:
          35cecb75-1eb7-4601-a70d-5b6975cfe32b:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 263
          'y': 113
