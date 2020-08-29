########################################################################################################################
#!!
#! @description: If temp folder_path given, it removes the folder. If no folder given, it removes the file. If none given, do nothing.
#!
#! @input folder_path: Temporal folder path
#! @input file_path: File path (does not have to be temporal!)
#!!#
########################################################################################################################
namespace: io.cloudslang.base.filesystem.temp
flow:
  name: delete_temp_file
  inputs:
    - folder_path:
        required: false
    - file_path:
        required: false
  workflow:
    - is_folder_path_given:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${folder_path}'
        navigate:
          - IS_NULL: is_file_path_given
          - IS_NOT_NULL: delete_temp_folder
    - delete_temp_folder:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${folder_path}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS
    - delete_file:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${file_path}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS
    - is_file_path_given:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${file_path}'
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: delete_file
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      is_file_path_given:
        x: 337
        'y': 96
        navigate:
          2c14317d-4a3e-92ef-4f0b-cbab5fd2e500:
            targetId: b3291298-f4a9-062b-dc8a-b6d19693ffe0
            port: IS_NULL
      delete_temp_folder:
        x: 114
        'y': 295
        navigate:
          0311d764-b027-85a5-0e20-891543c77f2a:
            targetId: b3291298-f4a9-062b-dc8a-b6d19693ffe0
            port: SUCCESS
          0d561c52-37c8-526b-8f0f-9fba75169659:
            targetId: b3291298-f4a9-062b-dc8a-b6d19693ffe0
            port: FAILURE
      delete_file:
        x: 552
        'y': 93
        navigate:
          f227b5ab-11c4-3070-27cf-660122bf3f4f:
            targetId: b3291298-f4a9-062b-dc8a-b6d19693ffe0
            port: SUCCESS
          702f6af0-84cc-89ca-3f01-e765351986eb:
            targetId: b3291298-f4a9-062b-dc8a-b6d19693ffe0
            port: FAILURE
      is_folder_path_given:
        x: 114
        'y': 98
    results:
      SUCCESS:
        b3291298-f4a9-062b-dc8a-b6d19693ffe0:
          x: 335
          'y': 296
