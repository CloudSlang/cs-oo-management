########################################################################################################################
#!!
#! @description: Gets authentication token from IDM service.
#!
#! @input generate_HPSSO: Set to true when when HPSSO required; necessary to authenticate to Designer
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.authenticate
flow:
  name: get_token
  inputs:
    - generate_HPSSO:
        default: 'false'
        required: false
    - rpa_username:
        required: false
    - rpa_password:
        required: false
    - idm_tenant:
        required: false
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'%s/v3.0/tokens' % get_sp('io.cloudslang.microfocus.rpa.idm_url') + ('?generateHPSSO=true' if generate_HPSSO.lower() == 'true' else \"\")}"
            - auth_type: basic
            - username: "${get_sp('io.cloudslang.microfocus.rpa.idm_username')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.rpa.idm_password')}"
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: 'Accept: application/json'
            - body: "${'{\"tenantName\":\"%s\",\"passwordCredentials\":{\"username\":\"%s\",\"password\":\"%s\"}}' % (get_sp(\"idm_tenant\") if idm_tenant is None else idm_tenant, get_sp(\"rpa_username\") if rpa_username is None else rpa_username, get_sp(\"rpa_password\") if rpa_password is None else rpa_password)}"
            - content_type: application/json;charset=UTF-8
        publish:
          - token_json: '${return_result}'
          - response_headers
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${token_json}'
            - json_path: $.token.id
        publish:
          - token: '${return_result[1:-1]}'
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
      http_client_post:
        x: 68
        'y': 150
      json_path_query:
        x: 239
        'y': 147
        navigate:
          2c798913-bfdf-fac4-7dde-35c99f94922b:
            targetId: 05f7289a-39ef-d301-224f-c04ca836dcfb
            port: SUCCESS
    results:
      SUCCESS:
        05f7289a-39ef-d301-224f-c04ca836dcfb:
          x: 402
          'y': 152
