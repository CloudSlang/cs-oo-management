########################################################################################################################
#!!
#! @description: Get flow executions.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.execution
flow:
  name: get_executions
  inputs:
    - page_size: '200'
    - page_num: '1'
  workflow:
    - central_http_action:
        do:
          io.cloudslang.microfocus.rpa.central._operations.central_http_action:
            - url: "${'/rest/latest/executions?pageSize=%s&pageNum=%s' % (page_size, page_num)}"
            - method: GET
        publish:
          - executions_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - executions_json: '${executions_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      central_http_action:
        x: 90
        'y': 99
        navigate:
          5edf02c6-ae29-10d7-cac2-15de9a10a702:
            targetId: 758cfec6-ce01-09da-81b8-ff6bfe5c6032
            port: SUCCESS
    results:
      SUCCESS:
        758cfec6-ce01-09da-81b8-ff6bfe5c6032:
          x: 263
          'y': 102
