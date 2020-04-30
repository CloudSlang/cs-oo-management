########################################################################################################################
#!!
#! @output status_code: 409 = the file is already imported
#!!#
########################################################################################################################
namespace: rpa.designer.rest.dependency.sub_flows
flow:
  name: upload_file
  inputs:
    - token
    - process_id
    - cp_file
  workflow:
    - designer_http_action:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/imports/%s/files' % process_id}"
            - token: '${token}'
            - method: POST
            - file: "${'content_pack=%s' % cp_file}"
        publish:
          - files_json: '${return_result}'
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - files_json: '${files_json}'
    - status_code: '${status_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 102
        'y': 123
        navigate:
          fcbcc589-1735-b1f0-87ac-67b3a8380b09:
            targetId: 4681c1cb-32dd-92c1-2adf-9693f944fcb5
            port: SUCCESS
    results:
      SUCCESS:
        4681c1cb-32dd-92c1-2adf-9693f944fcb5:
          x: 304
          'y': 125
