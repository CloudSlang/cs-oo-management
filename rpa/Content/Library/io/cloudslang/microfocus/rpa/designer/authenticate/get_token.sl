########################################################################################################################
#!!
#! @description: Authenticates to RPA Designer and returns the X-CSRF-TOKEN. This token is not required for read-only (HTTP GET) operations.
#!               To authenticate, one needs to execute two dummy HTTP REST API calls; second call then generates the X-CSRF-TOKEN.
#!               One can provide optional Workspace user's credentials (if not provided, the RPA admin credentials are used).
#!
#! @input ws_user: If not provided, default admin credentials will be used.
#! @input ws_password: If not provided, default admin credentials will be used.
#! @input ws_tenant: If not provided, default admin credentials will be used.
#!
#! @output token: X-CSRF-TOKEN that is required for Designer REST API
#! @output idm_token: IDM token (necessary for IDM REST API only)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.authenticate
flow:
  name: get_token
  inputs:
    - ws_user:
        required: false
    - ws_password:
        required: false
    - ws_tenant:
        required: false
  workflow:
    - get_idm_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token:
            - generate_HPSSO: 'true'
            - rpa_username: '${ws_user}'
            - rpa_password: '${ws_password}'
            - idm_tenant: '${ws_tenant}'
        publish:
          - idm_token: '${token}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: designer_http_action
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: /
            - method: GET
            - verify_result: html
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_x_csrf_token
    - get_x_csrf_token:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: /rest/v0/users/me
            - method: GET
        publish:
          - token: "${response_headers.split('X-CSRF-TOKEN:')[1].split('\\n')[0].strip()}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - token: '${token}'
    - idm_token: '${idm_token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_idm_token:
        x: 77
        'y': 131
      designer_http_action:
        x: 241
        'y': 136
      get_x_csrf_token:
        x: 77
        'y': 282
        navigate:
          78d3c095-e150-a0e5-c363-41882c7fc3e2:
            targetId: ebb84087-7827-90a8-a559-5a9ec89f4e53
            port: SUCCESS
    results:
      SUCCESS:
        ebb84087-7827-90a8-a559-5a9ec89f4e53:
          x: 240
          'y': 288
