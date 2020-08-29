########################################################################################################################
#!!
#! @description: Retrieves a list of files in the directory matching the pattern. 
#!               The returned list will contain forward slashes or back slashes depending on what contained the input pattern.
#!
#! @input pattern: Full path and pattern which files to include; e.g. C:/Temp/*.txt
#! @input full_path: If false, only base file names are returned
#!
#! @output files: List of files in the directory matching the pattern
#!!#
########################################################################################################################
namespace: io.cloudslang.base.filesystem
operation:
  name: list_files
  inputs:
    - pattern
    - full_path: 'true'
  python_action:
    use_jython: false
    script: "import glob, os\ndef execute(pattern, full_path): \n    files_list = glob.glob(pattern)\n    if full_path == 'true':\n        files = files_list\n    else:\n        files = [os.path.basename(x) for x in files_list]\n    return {\"files\" : str(files) }"
  outputs:
    - files: '${files}'
  results:
    - SUCCESS
