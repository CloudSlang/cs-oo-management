########################################################################################################################
#!!
#! @description: Imports the provided CP and assigns it to the user default workspace.
#!
#! @input ws_user: Workspace user name (if not provided RPA admin's credentials are used instead)
#! @input ws_password: Workspace user password (if not provided RPA admin's credentials are used instead)
#! @input ws_tenant: Workspace tenant (if not provided, default is used instead)
#! @input cp_url: CP URL to be deployed
#! @input folder_path: If given, the CP will downloaded here and kept permanently
#! @input assign: If true, it also assigns the CP to the default WS
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.content-pack.test
flow:
  name: test_import_cp_from_url
  inputs:
    - ws_user:
        required: false
    - ws_password:
        required: false
    - ws_tenant:
        required: false
    - cp_url:
        default: 'https://github.com/pe-pan/rpa-aos/releases/download/1.0.2/AOS-cp-1.0.2.jar'
        required: false
    - folder_path:
        default: "c:\\\\temp"
        required: false
    - assign:
        default: 'true'
        required: false
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.designer.authenticate.get_token:
            - ws_user: '${ws_user}'
            - ws_password: '${ws_password}'
            - ws_tenant: '${ws_tenant}'
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_default_ws_id
    - get_default_ws_id:
        do:
          io.cloudslang.microfocus.rpa.designer.workspace.get_default_ws_id: []
        publish:
          - ws_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_cp_from_url
    - import_cp_from_url:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.import_cp_from_url:
            - token: '${token}'
            - cp_url: '${cp_url}'
            - ws_id: "${ws_id if assign.lower() == 'true' else None}"
            - file_path: '${folder_path if folder_path is None else folder_path+"/"+cp_url.split("/")[-1]}'
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
        x: 45
        'y': 89
      get_default_ws_id:
        x: 45
        'y': 303
      import_cp_from_url:
        x: 231
        'y': 302
        navigate:
          0e346614-2f93-301a-91f8-9534ac9a766a:
            targetId: bd8aeb85-c6b9-b7a0-e088-8d020ab18e35
            port: SUCCESS
    results:
      SUCCESS:
        bd8aeb85-c6b9-b7a0-e088-8d020ab18e35:
          x: 230
          'y': 88
