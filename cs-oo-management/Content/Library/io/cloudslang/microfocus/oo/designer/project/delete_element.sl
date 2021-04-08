########################################################################################################################
#!!
#! @description: Removes the given folder or the file from the project including all sub-elements (in case a folder is given).
#!
#! @input element_id: ID of the folder or file (flow, operation or activity)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.designer.project
flow:
  name: delete_element
  inputs:
    - token
    - element_id
  workflow:
    - designer_http_action:
        do:
          io.cloudslang.microfocus.oo.designer._operations.designer_http_action:
            - url: "${'/rest/v0/elements/%s' % element_id}"
            - token: '${token}'
            - method: DELETE
            - verify_result: no_verification
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 40
        'y': 75
        navigate:
          84d2c636-6cba-eb04-c3d4-995c7259347d:
            targetId: 9ec70a01-3d59-1c1d-fc16-3f1f19d9548c
            port: SUCCESS
    results:
      SUCCESS:
        9ec70a01-3d59-1c1d-fc16-3f1f19d9548c:
          x: 257
          'y': 75
