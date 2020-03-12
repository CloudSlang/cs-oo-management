########################################################################################################################
#!!
#! @description: Creates demo categories.
#!
#! @input categories: A list of categories to be created; each category contains name, description, background ID and icon ID. The name must be unique.
#!!#
########################################################################################################################
namespace: demo
flow:
  name: create_ssx_categories
  inputs:
    - categories: 'AOS3,Advantage Online Shopping,null,200026|HR3,Human Resources,200055,200007|INSURANCE3,Insurance & Assurance,200070,200005|IT3,Information Technology,200068,200021|SALESFORCE3,Sales & Force,200071,200025|SAP3,System Analysis and Program Development,200061,200047'
    - category_delimiter: '|'
    - value_delimiter: ','
  workflow:
    - get_token:
        do:
          ssx.rest.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_category
    - add_category:
        loop:
          for: category in categories.split(category_delimiter)
          do:
            ssx.rest.category.add_category:
              - token: '${token}'
              - name: '${category.split(value_delimiter)[0]}'
              - description: '${category.split(value_delimiter)[1]}'
              - background_id: '${category.split(value_delimiter)[2]}'
              - icon_id: '${category.split(value_delimiter)[3]}'
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
