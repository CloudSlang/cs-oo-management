namespace: io.cloudslang.microfocus.rpa.designer.content-pack.test
flow:
  name: test_deploy_cp
  inputs:
    - ws_user:
        required: false
    - cp_file
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${ws_user}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_cp
    - deploy_cp:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.deploy_cp:
            - token: '${token}'
            - cp_file: '${cp_file}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - ALREADY_DEPLOYED: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 96
        'y': 88
      deploy_cp:
        x: 265
        'y': 84
        navigate:
          0d1cd0cd-d1cd-12f7-ed41-2cd6946b08d1:
            targetId: d844c66b-29f0-8ce6-598e-39aa803eb462
            port: SUCCESS
          686ad1d3-d4a4-1994-a98a-88088ae7adc0:
            targetId: d844c66b-29f0-8ce6-598e-39aa803eb462
            port: ALREADY_DEPLOYED
    results:
      SUCCESS:
        d844c66b-29f0-8ce6-598e-39aa803eb462:
          x: 423
          'y': 77
