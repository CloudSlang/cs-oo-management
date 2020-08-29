########################################################################################################################
#!!
#! @input retries: How many times to retry when API call fails
#!!#
########################################################################################################################
namespace: io.cloudslang.base.github._operations
flow:
  name: github_http_action
  inputs:
    - url
    - method
    - retries:
        default: '10'
        private: true
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'https://api.github.com%s' % url}"
            - auth_type: anonymous
            - method: '${method}'
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
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
        x: 77
        'y': 110
        navigate:
          eea58ce5-75de-985e-514d-0311e373704f:
            targetId: 66aec9a2-43df-575e-f00b-3d863c982988
            port: SUCCESS
    results:
      SUCCESS:
        66aec9a2-43df-575e-f00b-3d863c982988:
          x: 288
          'y': 112
