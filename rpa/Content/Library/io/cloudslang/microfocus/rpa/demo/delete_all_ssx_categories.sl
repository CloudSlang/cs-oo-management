namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: delete_all_ssx_categories
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_categories
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${categories_json}'
            - json_path: '$.items.*.id'
        publish:
          - category_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: delete_category
          - FAILURE: on_failure
    - get_categories:
        do:
          io.cloudslang.microfocus.rpa.ssx.category.get_categories:
            - token: '${token}'
        publish:
          - categories_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - delete_category:
        loop:
          for: id in category_ids
          do:
            io.cloudslang.microfocus.rpa.ssx.category.delete_category:
              - token: '${token}'
              - id: '${id}'
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
        x: 44
        'y': 118
      json_path_query:
        x: 357
        'y': 123
      get_categories:
        x: 200
        'y': 118
      delete_category:
        x: 526
        'y': 128
        navigate:
          9241c376-52b2-25f5-b9bc-19264be89b47:
            targetId: 2f8866bb-a2b3-0c58-b8de-0c280c83c36f
            port: SUCCESS
    results:
      SUCCESS:
        2f8866bb-a2b3-0c58-b8de-0c280c83c36f:
          x: 669
          'y': 137
