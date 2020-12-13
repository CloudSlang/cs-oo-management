namespace: io.test
flow:
  name: test
  workflow:
    - get_temp_file:
        do:
          io.cloudslang.base.filesystem.temp.get_temp_file:
            - file_name: something
        publish:
          - folder_path
          - file_path
        navigate:
          - SUCCESS: delete
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${folder_path}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_temp_file:
        x: 106
        'y': 119
      delete:
        x: 291
        'y': 127
        navigate:
          92483819-d038-1244-32ed-cb7900a8ae34:
            targetId: e51806f2-68cd-2b24-a8ba-7d84f7fdba2d
            port: SUCCESS
    results:
      SUCCESS:
        e51806f2-68cd-2b24-a8ba-7d84f7fdba2d:
          x: 471
          'y': 131
