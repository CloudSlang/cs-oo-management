########################################################################################################################
#!!
#! @description: Receives the organization ID.
#!
#! @input org_name: Organization name
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.idm.organization
flow:
  name: get_organization_id
  inputs:
    - token
    - org_name: RPA
  workflow:
    - get_organizations:
        do:
          io.cloudslang.microfocus.rpa.idm.organization.get_organizations:
            - token: '${token}'
        publish:
          - organizations_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${organizations_json}'
            - json_path: "${\"$.organizations.[?(@.name=='%s')].id\" % org_name}"
        publish:
          - org_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - org_id: '${org_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_organizations:
        x: 67
        'y': 112
      json_path_query:
        x: 219
        'y': 117
        navigate:
          1b67838c-8d3a-ccc4-602e-2de6336ca218:
            targetId: 23abcc90-f29e-69b6-9dd3-c3e49052f211
            port: SUCCESS
    results:
      SUCCESS:
        23abcc90-f29e-69b6-9dd3-c3e49052f211:
          x: 355
          'y': 116
