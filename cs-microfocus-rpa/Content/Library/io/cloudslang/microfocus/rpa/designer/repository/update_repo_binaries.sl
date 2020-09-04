########################################################################################################################
#!!
#! @description: Imports the GitHub repository but before that, it imports the latest release attached to the repository and also removes this imported CP from the workspace. This was possible binary artifacts (RPA activities) will get updated in the library of binaries.
#!
#! @input github_repo: Git Hub repo owner/name of a repo to be imported
#! @input cp_folder: If given, the downloaded binaries will be stored permanently in this folder (otherwise downloaded temporarily and removed after import)
#!
#! @output status_json: JSON of the binaries upload status
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.repository
flow:
  name: update_repo_binaries
  inputs:
    - token
    - ws_id
    - github_repo
    - cp_folder:
        required: false
  workflow:
    - get_repo_details:
        do:
          io.cloudslang.base.github.get_repo_details:
            - owner: "${github_repo.split('/')[0]}"
            - repo: "${github_repo.split('/')[1]}"
        publish:
          - clone_url
          - release_binary_url
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_cp_from_url
          - NO_RELEASE: NO_BINARIES
    - import_cp_from_url:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.import_cp_from_url:
            - token: '${token}'
            - cp_url: '${release_binary_url}'
            - ws_id: '${ws_id}'
            - file_path: '${cp_folder if cp_folder is None else cp_folder+"/"+release_binary_url.split("/")[-1]}'
        publish:
          - status_json
          - cp_id: "${eval(status_json)[0].get('contentPackId','') if type(eval(status_json)) is list else ''}"
        navigate:
          - SUCCESS: unassign_cp
          - FAILURE: on_failure
    - unassign_cp:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.unassign_cp:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - cp_id: '${cp_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - status_json: '${status_json}'
  results:
    - SUCCESS
    - FAILURE
    - NO_BINARIES
extensions:
  graph:
    steps:
      get_repo_details:
        x: 69
        'y': 87
        navigate:
          40880392-fee1-beef-0d2a-5e254cff3170:
            targetId: 4b14184b-3818-93fa-6dff-1c96e3449561
            port: NO_RELEASE
      import_cp_from_url:
        x: 288
        'y': 89
      unassign_cp:
        x: 488
        'y': 84
        navigate:
          d3bf7a2b-0dca-21b5-c02c-ac16e93b08d5:
            targetId: 02a1a501-c474-69f5-d4dd-21bdeaac9ab0
            port: SUCCESS
    results:
      SUCCESS:
        02a1a501-c474-69f5-d4dd-21bdeaac9ab0:
          x: 657
          'y': 75
      NO_BINARIES:
        4b14184b-3818-93fa-6dff-1c96e3449561:
          x: 74
          'y': 275
