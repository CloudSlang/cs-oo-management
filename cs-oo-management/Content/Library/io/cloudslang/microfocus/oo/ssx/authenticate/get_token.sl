########################################################################################################################
#!!
#! @description: Receives X-CSRF-TOKEN. This token needs to be sent along with requests against SSX REST API endpoints.
#!
#! @output token: X-CSRF-TOKEN
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.ssx.authenticate
flow:
  name: get_token
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${get_sp('io.cloudslang.microfocus.oo.ssx_url')}"
            - auth_type: basic
            - username: "${get_sp('io.cloudslang.microfocus.oo.rpa_username')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.oo.rpa_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.oo.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.oo.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.oo.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.oo.proxy_password')}"
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - content_type: application/json
            - method: HEAD
        publish:
          - token: "${response_headers.split('X-CSRF-TOKEN:')[1].split('\\n')[0].strip()}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 84
        'y': 77
        navigate:
          0dbc8b33-8888-6463-1780-afd3d09b49cc:
            targetId: 3a5d00ef-7493-21f2-bcf9-a60215f85b92
            port: SUCCESS
    results:
      SUCCESS:
        3a5d00ef-7493-21f2-bcf9-a60215f85b92:
          x: 237
          'y': 76
