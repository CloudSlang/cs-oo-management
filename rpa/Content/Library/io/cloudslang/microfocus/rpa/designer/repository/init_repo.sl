########################################################################################################################
#!!
#! @description: Imports the GitHub repository but before that, it imports the latest release attached to the repository and also removes this imported CP from the workspace. This was possible binary artifacts (RPA activities) will get updated in the library of binaries.
#!
#! @input github_repo: Git Hub repo owner/name of a repo to be imported
#! @input update_binaries: If yes, the latest release will be downloaded to the workspace dependencies and then removed
#! @input cp_folder: If given, the downloaded binaries will be stored permanently in this folder (otherwise donwloaded temporarily and removed after import)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.repository
flow:
  name: init_repo
  inputs:
    - token
    - ws_id
    - github_repo
    - update_binaries
    - cp_folder
  workflow:
    - get_repo_details:
        do:
          io.cloudslang.base.github.get_repo_details:
            - owner: "${github_repo.split('/')[0]}"
            - repo: "${github_repo.split('/')[1]}"
            - update_binaries: '${update_binaries}'
        publish:
          - clone_url
          - release_binary_url: "${release_binary_url if update_binaries.lower() == 'yes' else ''}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_latest_release
          - NO_RELEASE: import_repo
    - import_cp_from_url:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.import_cp_from_url:
            - token: '${token}'
            - cp_url: '${release_binary_url}'
            - ws_id: '${ws_id}'
            - file_path: "${'' if cp_folder is None else cp_folder+\"/\"+release_binary_url.split(\"/\")[-1]}"
        publish:
          - status_json
          - cp_id: "${eval(status_json)[0]['contentPackId']}"
        navigate:
          - SUCCESS: import_repo
          - FAILURE: on_failure
    - import_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.import_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - scm_url: '${clone_url}'
        publish:
          - status_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: remove_cp
    - import_latest_release:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(release_binary_url) > 0)}'
        navigate:
          - 'TRUE': import_cp_from_url
          - 'FALSE': import_repo
    - unassign_cp:
        do:
          io.cloudslang.microfocus.rpa.designer.content-pack.unassign_cp:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - cp_id: '${cp_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - remove_cp:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(release_binary_url) > 0)}'
        navigate:
          - 'TRUE': unassign_cp
          - 'FALSE': SUCCESS
  outputs:
    - status_json: '${status_json}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_repo_details:
        x: 69
        'y': 87
      import_cp_from_url:
        x: 478
        'y': 310
      import_repo:
        x: 477
        'y': 85
      import_latest_release:
        x: 232
        'y': 307
      unassign_cp:
        x: 893
        'y': 296
        navigate:
          f80cdb0d-1a1a-15ce-0eaa-ad73ce5e081e:
            targetId: 02a1a501-c474-69f5-d4dd-21bdeaac9ab0
            port: SUCCESS
      remove_cp:
        x: 693
        'y': 291
        navigate:
          7b67546f-f593-1f51-076d-eca9dd3c033b:
            targetId: 02a1a501-c474-69f5-d4dd-21bdeaac9ab0
            port: 'FALSE'
    results:
      SUCCESS:
        02a1a501-c474-69f5-d4dd-21bdeaac9ab0:
          x: 887
          'y': 79
