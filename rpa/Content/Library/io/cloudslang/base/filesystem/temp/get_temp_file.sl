########################################################################################################################
#!!
#! @description: Creates a temporal folder and generates a temporal file name inside the folder
#!
#! @input file_name: The created file_name
#!
#! @output folder_path: Temporally created folder
#! @output file_path: Temporal file (not created yet); full path
#!!#
########################################################################################################################
namespace: io.cloudslang.base.filesystem.temp
operation:
  name: get_temp_file
  inputs:
    - file_name:
        required: true
  python_action:
    use_jython: false
    script: "import os, tempfile\ndef execute(file_name): \n    folder_path = tempfile.mkdtemp()\n    file_path = os.path.join(folder_path, file_name)\n    return { 'folder_path' : folder_path, 'file_path' : file_path }"
  outputs:
    - folder_path
    - file_path
  results:
    - SUCCESS
