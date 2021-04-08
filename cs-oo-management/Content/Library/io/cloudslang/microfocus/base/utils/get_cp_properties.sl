########################################################################################################################
#!!
#! @description: Retrives content pack properties out of the given CP file.
#!
#! @input cp_file: CP file full path (the jar file)
#! @input file_name: File inside of the jar file containing the properties
#!
#! @output cp_desc: CP description
#! @output cp_name: CP name
#! @output cp_pub: CP publisher
#! @output cp_version: CP version
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.base.utils
operation:
  name: get_cp_properties
  inputs:
    - cp_file
    - file_name:
        private: true
        default: contentpack.properties
  python_action:
    script: "import zipfile, ConfigParser, StringIO\narchive = zipfile.ZipFile(cp_file, 'r')\n\nfile_content = archive.read(file_name).decode('UTF-8')  # decode otherwise it's a byte stream\n\nconfig = ConfigParser.ConfigParser()\nbuf = StringIO.StringIO(\"[top]\\n\" + file_content)             # add [top] section (configparser needs sections)\nconfig.readfp(buf)\n\ncp_desc = config.get('top', 'content.pack.description')\ncp_name = config.get('top', 'content.pack.name')\ncp_pub = config.get('top', 'content.pack.publisher')                     \ncp_version = config.get('top', 'content.pack.version')"
  outputs:
    - cp_desc: '${cp_desc}'
    - cp_name: '${cp_name}'
    - cp_pub: '${cp_pub}'
    - cp_version: '${cp_version}'
  results:
    - SUCCESS

