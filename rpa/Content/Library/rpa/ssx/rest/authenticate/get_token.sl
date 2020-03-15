########################################################################################################################
#!!
#! @description: Gets X-CSRF-TOKEN. This token needs to be sent along with requests against SSX REST API endpoints.
#!
#! @output token: X-CSRF-TOKEN
#!!#
########################################################################################################################
namespace: rpa.ssx.rest.authenticate
flow:
  name: get_token
  workflow:
    - ssx_http_action:
        do:
          rpa.tools.ssx_http_action:
            - url: "${get_sp('ssx_url')}"
            - method: HEAD
            - use_cookies: 'true'
        publish:
          - token: "${response_headers.split('X-CSRF-TOKEN:')[1].split('\\n')[0].strip()}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssx_http_action:
        x: 49
        'y': 86
        navigate:
          cdbf304b-e021-391e-f4bc-77246c744d56:
            targetId: 3a5d00ef-7493-21f2-bcf9-a60215f85b92
            port: SUCCESS
    results:
      SUCCESS:
        3a5d00ef-7493-21f2-bcf9-a60215f85b92:
          x: 237
          'y': 76
