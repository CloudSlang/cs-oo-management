namespace: io.cloudslang.microfocus.rpa.designer.workspace.test
flow:
  name: test_update_workspace
  inputs:
    - username: aosdev
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${username}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - get_default_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_workspace
    - update_workspace:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.update_workspace:
            - token: '${token}'
            - ws_id: '${ws_id}'
        publish:
          - process_status
          - status_json
          - binaries_status_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: logout
    - logout:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.logout: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 134
        'y': 115
      get_default_ws_id:
        x: 342
        'y': 117
      update_workspace:
        x: 539
        'y': 116
      logout:
        x: 712
        'y': 127
        navigate:
          0b2b7210-88ab-46cd-67b2-7860269649ff:
            targetId: 8ce08404-25fc-734a-68ab-7f8e24637112
            port: SUCCESS
    results:
      SUCCESS:
        8ce08404-25fc-734a-68ab-7f8e24637112:
          x: 864
          'y': 117
