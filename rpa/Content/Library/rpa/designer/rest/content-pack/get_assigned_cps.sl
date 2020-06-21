########################################################################################################################
#!!
#! @description: Retrieves all deployed Content Packs assigned in the given Workspace
#!!#
########################################################################################################################
namespace: rpa.designer.rest.content-pack
flow:
  name: get_assigned_cps
  inputs:
    - ws_id
  workflow:
    - designer_http_action:
        do:
          rpa.tools.designer_http_action:
            - url: "${'/rest/v0/workspaces/%s/dependencies' % ws_id}"
            - method: GET
        publish:
          - cps_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - cps_json: '${cps_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      designer_http_action:
        x: 66
        'y': 97
        navigate:
          f4163b51-d679-f504-8c9f-898e125620f7:
            targetId: bacd6de1-dadc-1b9d-6082-7e3e2c1f07e1
            port: SUCCESS
    results:
      SUCCESS:
        bacd6de1-dadc-1b9d-6082-7e3e2c1f07e1:
          x: 214
          'y': 96
