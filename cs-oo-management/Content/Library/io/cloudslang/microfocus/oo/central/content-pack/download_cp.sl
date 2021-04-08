########################################################################################################################
#!!
#! @description: Downloads the given Content Pack from Central.
#!
#! @input cp_id: Content Pack UUID
#! @input cp_file: Full path where to download the file; the file will be overwritten if already exists
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.central.content-pack
flow:
  name: download_cp
  inputs:
    - cp_id
    - cp_file
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.oo.central._operations.central_http_action:
            - url: "${'/rest/latest/content-file/' + cp_id}"
            - method: GET
            - file: '${cp_file}'
            - file_in: '${cp_file}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 106
        'y': 85
        navigate:
          d461e80b-d871-c57e-80b7-d4e704365bfc:
            targetId: 2a10a7df-463d-77a9-17b9-412c6294e114
            port: SUCCESS
    results:
      SUCCESS:
        2a10a7df-463d-77a9-17b9-412c6294e114:
          x: 284
          'y': 83
