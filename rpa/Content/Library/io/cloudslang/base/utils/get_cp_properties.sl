########################################################################################################################
#!!
#! @description: Retrives content pack properties out of the CP file
#!
#! @input cp_file: CP file path
#!
#! @output cp_desc: CP description
#! @output cp_name: CP name
#! @output cp_pub: CP publisher
#! @output cp_version: CP version
#!!#
########################################################################################################################
namespace: io.cloudslang.base.utils
operation:
  name: get_cp_properties
  inputs:
    - cp_file
    - file_name:
        private: true
        default: contentpack.properties
  python_action:
    use_jython: false
    script: "import zipfile, configparser\ndef execute(cp_file, file_name):\n    archive = zipfile.ZipFile(cp_file, 'r')\n\n    file_content = archive.read(file_name).decode('UTF-8')  # decode otherwise it's a byte stream\n\n    config = configparser.ConfigParser()\n    config.read_string(\"[top]\\n\" + file_content)            # add [top] section (configparser needs sections)\n    return { 'cp_desc' : config['top']['content.pack.description'],\n             'cp_name' : config['top']['content.pack.name'],                         \n             'cp_pub' : config['top']['content.pack.publisher'],                         \n             'cp_version' : config['top']['content.pack.version'] }"
  outputs:
    - cp_desc: '${cp_desc}'
    - cp_name: '${cp_name}'
    - cp_pub: '${cp_pub}'
    - cp_version: '${cp_version}'
  results:
    - SUCCESS
