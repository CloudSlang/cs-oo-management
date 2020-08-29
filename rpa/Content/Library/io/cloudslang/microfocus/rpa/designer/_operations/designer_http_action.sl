########################################################################################################################
#!!
#! @description: Sends HTTP request against Designer REST API endpoint. It verifies the output is JSON doc; provide value if the output is supposed not to be JSON doc.
#!
#! @input token: Only certain operations (import CP) needs to have the auth token; the rest are fine with auth token stored in cookies
#! @input file: File to be sent
#! @input verify_result: Provide json/html in case which value is expected to be returned; will fail if the result is not as expected (simple verification). Provide anything (even empty input) if no verification required.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer._operations
flow:
  name: designer_http_action
  inputs:
    - url
    - token:
        required: false
    - method
    - body:
        required: false
    - file:
        required: false
    - verify_result:
        default: json
        required: false
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'%s%s' % (get_sp('io.cloudslang.microfocus.rpa.designer_url'), url)}"
            - auth_type: anonymous
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - use_cookies: 'true'
            - headers: "${\"\" if token is None else 'X-CSRF-TOKEN: %s' % token}"
            - body: '${body}'
            - content_type: "${'application/json' if file is None else 'multipart/form-data'}"
            - multipart_files: '${file}'
            - method: '${method}'
            - verify_result: '${verify_result}'
        publish:
          - return_result
          - error_message
          - response_headers
          - status_code
          - result_verified: "${str(return_result[0:2].index(\"{\")) if verify_result == \"json\" else str(return_result[0:2].index(\"[\")) if verify_result == \"list\" else str(return_result[0:1].index(\"<\")) if verify_result == 'html' else \"no_verification\"}"
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
        x: 86
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
