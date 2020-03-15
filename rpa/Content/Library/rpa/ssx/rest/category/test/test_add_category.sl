namespace: rpa.ssx.rest.category.test
flow:
  name: test_add_category
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
        do:
          rpa.ssx.rest.category.add_category:
            - token: '${token}'
            - name: Test Cat
            - description: Test Desc
            - background_id: '200061'
            - icon_id: '200047'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_category:
        x: 252
        'y': 109
        navigate:
          a00bd6fb-6f31-5724-4227-38f8d78ded08:
            targetId: 73c29f2d-bc78-7f47-b090-6d8e17fde685
            port: SUCCESS
      get_token:
        x: 81
        'y': 104
    results:
      SUCCESS:
        73c29f2d-bc78-7f47-b090-6d8e17fde685:
          x: 420
          'y': 101
