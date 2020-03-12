########################################################################################################################
#!!
#! @description: Adds SSX category.
#!
#! @input token: X-CSRF-TOKEN obtained from get_token flow
#!!#
########################################################################################################################
namespace: ssx.rest.category
flow:
  name: add_category
  inputs:
    - token
    - name
    - description
    - background_id
    - icon_id
  workflow:
    - http_client_action:
        do:
          tools.http_client_action:
            - url: "${'%s/rest/v0/categories' % get_sp('ssx_url')}"
            - method: POST
            - body: |-
                ${'''
                  {
                    "name": "%s",
                    "description": "%s",
                    "backgroundId": %s,
                    "iconId": %s
                  }
                ''' % (name, description, background_id, icon_id)}
            - headers: "${'''X-CSRF-TOKEN: %s''' % token}"
            - use_cookies: 'true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 80
        'y': 80
        navigate:
          5b85ed26-4494-6546-434e-36f58877a30e:
            targetId: 0fc33028-6982-ffb4-682f-4b28028d19fe
            port: SUCCESS
    results:
      SUCCESS:
        0fc33028-6982-ffb4-682f-4b28028d19fe:
          x: 299
          'y': 83
