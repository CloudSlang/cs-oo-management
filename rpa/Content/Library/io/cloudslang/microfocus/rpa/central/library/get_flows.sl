########################################################################################################################
#!!
#! @description: Returns flows and folders under the given path.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.library
flow:
  name: get_flows
  inputs:
    - path: Library/Micro Focus/Misc
  workflow:
    - url_encoder:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: '${path}'
        publish:
          - path_enc: '${result}'
        navigate:
          - SUCCESS: central_http_action
          - FAILURE: on_failure
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/flows/tree/level?path=%s' % path_enc}"
            - method: GET
        publish:
          - flows_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - flows_json: '${flows_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      url_encoder:
        x: 75
        'y': 104
      central_http_action:
        x: 228
        'y': 107
        navigate:
          3fbb1476-aaf4-9742-fea3-9cac1b39766f:
            targetId: 05f7289a-39ef-d301-224f-c04ca836dcfb
            port: SUCCESS
    results:
      SUCCESS:
        05f7289a-39ef-d301-224f-c04ca836dcfb:
          x: 393
          'y': 111
