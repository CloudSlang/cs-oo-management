########################################################################################################################
#!!
#! @description: Imports the given SCM repository
#!
#! @input ws_id: Workspace ID
#! @input scm_url: Repository URL
#!
#! @output status_json: JSON doc describing the status of the import
#! @output host_json: JSON doc describing the status of registering the host
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.repository
flow:
  name: import_repo
  inputs:
    - token
    - ws_id
    - scm_url
  workflow:
    - register_scm:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: /rest/v0/connection-manager/register-host
            - token: '${token}'
            - method: POST
            - body: '${scm_url}'
        publish:
          - host_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_scm_id
    - import_scm:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/workspaces/%s/repositories/import' % ws_id}"
            - token: '${token}'
            - method: POST
            - body: |-
                ${'''{
                    "scmType": "",
                    "scmURL": "%s",
                    "protocolType": "%s",
                    "repositoryName": "",
                    "fullName": "",
                    "userEmail": "",
                    "username": "",
                    "userPassword": "",
                    "sshKeyId": "",
                    "isSshWithKeyId": false
                }''' % (scm_url, scm_url.split("://")[0].upper())}
        publish:
          - status_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_process_id
    - get_process_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${status_json}'
            - json_path: $.scmActionProcessId
        publish:
          - process_id: '${return_result}'
        navigate:
          - SUCCESS: get_process_status
          - FAILURE: on_failure
    - get_process_status:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/scm/processes/%s' % process_id}"
            - method: GET
        publish:
          - status_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${status_json}'
            - json_path: $.actionStatus
        publish:
          - process_status: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: is_running
          - FAILURE: on_failure
    - is_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${process_status}'
            - second_string: RUNNING
        navigate:
          - SUCCESS: sleep
          - FAILURE: is_finished
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: "${get_sp('io.cloudslang.microfocus.rpa.wait_time')}"
        navigate:
          - SUCCESS: get_process_status
          - FAILURE: on_failure
    - is_finished:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${process_status}'
            - second_string: FINISHED
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_scm_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${host_json}'
            - json_path: $.id
        publish:
          - scm_id: '${return_result}'
        navigate:
          - SUCCESS: accept_scm
          - FAILURE: on_failure
    - accept_scm:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: "${'/rest/v0/connection-manager/register-host/%s' % scm_id}"
            - token: '${token}'
            - method: PUT
            - body: 'true'
        publish:
          - accepted_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_scm
  outputs:
    - status_json: '${status_json}'
    - host_json: '${host_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      register_scm:
        x: 160
        'y': 15
      import_scm:
        x: 629
        'y': 13
      json_path_query:
        x: 174
        'y': 169
      accept_scm:
        x: 488
        'y': 10
      get_scm_id:
        x: 316
        'y': 12
      is_finished:
        x: 170
        'y': 514
        navigate:
          efbd723b-b4c6-0283-f6bb-4819b0ceb3f2:
            targetId: b2dfe55f-d1b5-4107-ddf7-4b6c999fc38a
            port: SUCCESS
      is_running:
        x: 169
        'y': 339
      get_process_status:
        x: 411
        'y': 171
      get_process_id:
        x: 631
        'y': 173
      sleep:
        x: 408
        'y': 340
    results:
      SUCCESS:
        b2dfe55f-d1b5-4107-ddf7-4b6c999fc38a:
          x: 418
          'y': 513
