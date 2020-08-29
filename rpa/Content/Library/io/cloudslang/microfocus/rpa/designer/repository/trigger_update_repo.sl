########################################################################################################################
#!!
#! @description: Triggers the process of updating SCM repository (pull) but does not wait for the process to finish.
#!
#! @output process_json: JSON of the SCM pull process
#! @output process_id: Process ID
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.repository
flow:
  name: trigger_update_repo
  inputs:
    - token
    - repo_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/scm/repositories/%s/pull' % repo_id}"
            - token: '${token}'
            - method: POST
        publish:
          - process_json: '${return_result}'
          - process_id: "${str(eval(return_result)['scmActionProcessId'])}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - process_json: '${process_json}'
    - process_id: '${process_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 60
        'y': 106
        navigate:
          8cc559cd-1a6d-7988-a2b6-8e7368d89ba5:
            targetId: ec7ea7c2-084e-baee-3801-c7b3a1840ad1
            port: SUCCESS
    results:
      SUCCESS:
        ec7ea7c2-084e-baee-3801-c7b3a1840ad1:
          x: 239
          'y': 110
