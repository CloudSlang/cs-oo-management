########################################################################################################################
#!!
#! @description: Helper method for GitHub REST API. In case the call exceeds the limit in number of calls the API allows, it waits for the window to open and repeats the call.
#!
#! @input url: Relative URL to be prefixed with https://api.github.com
#! @input method: HTTP method
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.base.github._operations
flow:
  name: github_http_action
  inputs:
    - url
    - method
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'https://api.github.com%s' % url}"
            - auth_type: anonymous
            - tls_version: "${get_sp('io.cloudslang.microfocus.oo.tls_version')}"
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.oo.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.oo.x_509_hostname_verifier')}"
            - method: '${method}'
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: is_403
    - is_403:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '403'
        navigate:
          - SUCCESS: get_remaining_reset_headers
          - FAILURE: on_failure
    - limit_exceeded:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ratelimit_remaining}'
            - second_string: '0'
        navigate:
          - SUCCESS: get_millis
          - FAILURE: on_failure
    - get_millis:
        do:
          io.cloudslang.microfocus.base.datetime.get_millis: []
        publish:
          - time_millis
        navigate:
          - SUCCESS: sleep
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${str(int(ratelimit_reset)-round(int(time_millis)/1000)+1)}'
        navigate:
          - SUCCESS: http_client_action
          - FAILURE: on_failure
    - get_remaining_reset_headers:
        do:
          io.cloudslang.base.utils.do_nothing:
            - response_headers: '${response_headers}'
        publish:
          - ratelimit_remaining: "${response_headers.split('X-Ratelimit-Remaining:')[1].split('\\n')[0].strip()}"
          - ratelimit_reset: "${response_headers.split('X-Ratelimit-Reset:')[1].split('\\n')[0].strip()}"
        navigate:
          - SUCCESS: limit_exceeded
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
    - return_code: '${return_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_action:
        x: 145
        'y': 204
        navigate:
          eea58ce5-75de-985e-514d-0311e373704f:
            targetId: 66aec9a2-43df-575e-f00b-3d863c982988
            port: SUCCESS
      is_403:
        x: 143
        'y': 400
      limit_exceeded:
        x: 575
        'y': 399
      get_millis:
        x: 575
        'y': 205
      sleep:
        x: 375
        'y': 205
      get_remaining_reset_headers:
        x: 371
        'y': 401
    results:
      SUCCESS:
        66aec9a2-43df-575e-f00b-3d863c982988:
          x: 141
          'y': 27
