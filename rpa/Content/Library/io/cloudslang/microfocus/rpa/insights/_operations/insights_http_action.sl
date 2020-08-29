########################################################################################################################
#!!
#! @description: HTTP client action (GET, POST, PUT, DELETE). It only accepts url and body; it uses basic authentication with RPA credentials (taken from RPE central system properties).
#!               It does not use cookies (to handle X-CSRF-TOKEN).
#!               It's a copy of central_http_action.
#!
#! @input method: GET, POST, PUT, DELETE
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.insights._operations
flow:
  name: insights_http_action
  inputs:
    - url
    - method
    - body:
        required: false
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s%s' % (get_sp('io.cloudslang.microfocus.rpa.insights_url'), url)}"
            - auth_type: basic
            - username: "${get_sp('io.cloudslang.microfocus.rpa.rpa_username')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.rpa.rpa_password')}"
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - use_cookies: 'false'
            - body: '${body}'
            - content_type: application/json
            - method: '${method}'
        publish:
          - return_result
          - response_headers
          - error_message
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 136
        'y': 123
        navigate:
          1276763d-c63f-7564-93ff-9d45c6ff7039:
            targetId: 7ad9349e-7386-7bde-dbe8-328c348b169f
            port: SUCCESS
    results:
      SUCCESS:
        7ad9349e-7386-7bde-dbe8-328c348b169f:
          x: 306
          'y': 114
