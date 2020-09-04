########################################################################################################################
#!!
#! @description: Updates the content pack (based on the CP name in the given URL) in Central if different than the one already deployed in Central.
#!
#! @input cp_url: The content pack to be deployed
#! @input cp_folder: If given, the CP will be downloaded and kept in this folder (even once this update finishes)
#!
#! @output cp_name: Content pack name
#! @output cp_version: Version which got deployed from the file
#! @output updated: true/false if the CP got deployed (updated) or not
#!
#! @result FAILURE: Failure when deploying the CP
#! @result ALREADY_DEPLOYED: The found CP has been already deployed
#! @result SUCCESS: The CP got deployed successfully
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.content-pack
flow:
  name: update_cp_from_url
  inputs:
    - cp_url
    - cp_folder:
        required: false
  workflow:
    - download_file:
        do:
          io.cloudslang.base.utils.download_file:
            - file_url: '${cp_url}'
            - file_path: '${cp_folder if cp_folder is None else cp_folder+"/"+cp_url.split("/")[-1]}'
        publish:
          - downloaded_file_path
          - folder_path
        navigate:
          - SUCCESS: update_cp
          - FAILURE: on_failure
    - update_cp:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.update_cp:
            - cp_file: '${downloaded_file_path}'
        publish:
          - updated
          - cp_name
          - cp_version
          - original_cp_version
        navigate:
          - FAILURE: on_failure
          - SUCCESS: cp_folder_provided
          - ALREADY_DEPLOYED: cp_folder_provided
    - cp_folder_provided:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(cp_folder is not None)}'
        navigate:
          - 'TRUE': has_been_updated
          - 'FALSE': delete
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${folder_path}'
        navigate:
          - SUCCESS: has_been_updated
          - FAILURE: has_been_updated
    - has_been_updated:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${updated}'
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': ALREADY_DEPLOYED
  outputs:
    - cp_name: '${cp_name}'
    - cp_version: '${cp_version}'
    - updated: '${updated}'
  results:
    - FAILURE
    - ALREADY_DEPLOYED
    - SUCCESS
extensions:
  graph:
    steps:
      download_file:
        x: 107
        'y': 123
      update_cp:
        x: 292
        'y': 127
      cp_folder_provided:
        x: 545
        'y': 139
      delete:
        x: 740
        'y': 145
      has_been_updated:
        x: 551
        'y': 372
        navigate:
          710415b1-209e-435a-406c-bb14230f57ac:
            targetId: 9520fdd2-7233-dd6c-a16b-85884208b552
            port: 'FALSE'
          3a6d1c41-75cc-4993-5e16-584725500f25:
            targetId: fabc933a-8bdb-7791-e331-1ece426bbe09
            port: 'TRUE'
    results:
      ALREADY_DEPLOYED:
        9520fdd2-7233-dd6c-a16b-85884208b552:
          x: 547
          'y': 557
      SUCCESS:
        fabc933a-8bdb-7791-e331-1ece426bbe09:
          x: 745
          'y': 373
