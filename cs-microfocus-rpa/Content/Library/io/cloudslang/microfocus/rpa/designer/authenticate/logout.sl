########################################################################################################################
#!!
#! @description: Logs out the current Designer user. If not called, get_token will not connect a new user.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.authenticate
flow:
  name: logout
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.rpa.designer._operations.designer_http_action:
            - url: /j_spring_security_logout
            - method: GET
            - verify_result: nothing
        navigate:
          - FAILURE: SUCCESS
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 69
        'y': 100
        navigate:
          23f80561-79f7-419b-5ff5-a1efe0465481:
            targetId: a582ad8e-928a-8f2a-93af-4fdeec2b34dd
            port: SUCCESS
          0db45950-f07f-c9a7-b5e0-2f435963261b:
            targetId: a582ad8e-928a-8f2a-93af-4fdeec2b34dd
            port: FAILURE
    results:
      SUCCESS:
        a582ad8e-928a-8f2a-93af-4fdeec2b34dd:
          x: 243
          'y': 95
