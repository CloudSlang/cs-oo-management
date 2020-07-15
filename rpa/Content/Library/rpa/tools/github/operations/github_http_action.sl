########################################################################################################################
#!!
#! @input retries: How many times to retry when API call fails
#!!#
########################################################################################################################
namespace: rpa.tools.github.operations
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
          - FAILURE: is_limit_exceeded
    - is_limit_exceeded:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str('API rate limit exceeded' in return_result)}"
        navigate:
          - 'TRUE': should_retry
          - 'FALSE': FAILURE
    - should_retry:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(int(retries) > 0)}'
            - retries: '${retries}'
        publish:
          - retries: '${str(int(retries) - 1)}'
        navigate:
          - 'TRUE': random_number_generator
          - 'FALSE': FAILURE
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: "${get_sp('wait_time')}"
            - max: "${str(int(get_sp('wait_time')) * 5)}"
        publish:
          - wait_time: '${random_number}'
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${wait_time}'
        navigate:
          - SUCCESS: http_client_action
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
      is_limit_exceeded:
        x: 75
        'y': 309
        navigate:
          5d94d380-46bd-ad36-de79-1fdd6dc87bca:
            targetId: 9960173e-8848-4137-1334-93e804728587
            port: 'FALSE'
      should_retry:
        x: 272
        'y': 494
        navigate:
          affa9666-776d-f957-72d3-79be097b02c9:
            targetId: 9960173e-8848-4137-1334-93e804728587
            port: 'FALSE'
      random_number_generator:
        x: 478
        'y': 495
      sleep:
        x: 478
        'y': 110
    results:
      SUCCESS:
        66aec9a2-43df-575e-f00b-3d863c982988:
          x: 286
          'y': 307
      FAILURE:
        9960173e-8848-4137-1334-93e804728587:
          x: 71
          'y': 495
