########################################################################################################################
#!!
#! @description: Creates demo categories.
#!
#! @input categories_json: JSON with a list of categories to be created; each category contains name, description, background ID and icon ID. The name must be unique. Null values need to be enclosed in quotes.
#!!#
########################################################################################################################
namespace: rpa.demo
flow:
  name: create_ssx_categories
  inputs:
    - categories_json: |-
        ${'''
        [
          {
            "name": "AOS3",
            "description": "Advantage Online Shopping",
            "backgroundId": "null",
            "iconId": 200026
          },
          {
            "name": "HR3",
            "description": "Human Resources",
            "backgroundId": 200055,
            "iconId": 200007
          },
          {
            "name": "INSURANCE3",
            "description": "Insurance & Assurance",
            "backgroundId": 200070,
            "iconId": 200005
          },
          {
            "name": "IT3",
            "description": "Information Technology",
            "backgroundId": 200068,
            "iconId": 200021
          },
          {
            "name": "SALESFORCE3",
            "description": "Sales & Force",
            "backgroundId": 200071,
            "iconId": 200025
          },
          {
            "name": "SAP3",
            "description": "System Analysis and Program Development",
            "backgroundId": 200061,
            "iconId": 200047
          }
        ]
        '''}
  workflow:
    - get_token:
        do:
          rpa.ssx.rest.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_category
    - add_category:
        loop:
          for: category_json in eval(categories_json)
          do:
            rpa.ssx.rest.category.add_category:
              - token: '${token}'
              - category_json: "${str(category_json).replace(\"'null'\", \"null\").replace(\"'\", '\"')}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 107
        'y': 123
      add_category:
        x: 244
        'y': 128
        navigate:
          989e1362-bb7b-1d2c-a06f-ff4b1f1efd00:
            targetId: 8ce4c69c-e2dd-917a-b954-5b1eb611845e
            port: SUCCESS
    results:
      SUCCESS:
        8ce4c69c-e2dd-917a-b954-5b1eb611845e:
          x: 394
          'y': 129
