namespace: io.cloudslang.base.filesystem.test
flow:
  name: test_list_files
  workflow:
    - list_files:
        do:
          io.cloudslang.base.filesystem.list_files:
            - pattern: 'C:/Users/Administrator/Downloads/content-packs/*.jar'
            - full_path: 'false'
        publish:
          - files
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      list_files:
        x: 102
        'y': 115
        navigate:
          4462808b-f29a-5f5f-fa0d-1406d693916d:
            targetId: 33b5fd15-6233-56b8-c961-9c2bcfb690e4
            port: SUCCESS
    results:
      SUCCESS:
        33b5fd15-6233-56b8-c961-9c2bcfb690e4:
          x: 275
          'y': 119
