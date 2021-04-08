########################################################################################################################
#!!
#! @description: Imports (or updates if already imported) the GitHub repository but before that, it imports the latest release attached to the repository and also unassigns this imported CP from the workspace. This way, the possible binary artifacts (RPA activities) will get updated in the library of binaries.
#!
#! @input ws_id: Workspace ID
#! @input github_repo: Git Hub repo owner/name of a repo to be imported
#! @input update_binaries: If yes, the latest release will be downloaded to the workspace dependencies and then removed
#! @input cp_folder: If given, the downloaded binaries will be stored permanently in this folder (otherwise donwloaded temporarily and removed after import)
#!
#! @output status_json: JSON document describing the status of the import
#! @output failure: Cause of the failure if the flow fails
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo.designer.repository
flow:
  name: init_repo
  inputs:
    - token
    - ws_id
    - github_repo
    - update_binaries
    - cp_folder
  workflow:
    - get_github_repo_details:
        do:
          io.cloudslang.base.github.get_repo_details:
            - owner: "${github_repo.split('/')[0]}"
            - repo: "${github_repo.split('/')[1]}"
            - update_binaries: '${update_binaries}'
        publish:
          - clone_url
          - release_binary_url: "${release_binary_url if update_binaries.lower() == 'yes' else ''}"
          - failure: ''
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_latest_release
          - NO_RELEASE: get_repo_details
    - import_cp_from_url:
        do:
          io.cloudslang.microfocus.oo.designer.content-pack.import_cp_from_url:
            - token: '${token}'
            - cp_url: '${release_binary_url}'
            - ws_id: '${ws_id}'
            - file_path: "${'' if cp_folder is None else cp_folder+\"/\"+release_binary_url.split(\"/\")[-1]}"
        publish:
          - status_json
          - cp_id: "${eval(status_json)[0]['contentPackId']}"
        navigate:
          - SUCCESS: get_repo_details
          - FAILURE: import_cp_failed
    - import_repo:
        do:
          io.cloudslang.microfocus.oo.designer.repository.import_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - scm_url: '${clone_url}'
        publish:
          - status_json
        navigate:
          - FAILURE: import_repo_failed
          - SUCCESS: remove_cp
    - import_latest_release:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(release_binary_url) > 0)}'
        navigate:
          - 'TRUE': import_cp_from_url
          - 'FALSE': get_repo_details
    - unassign_cp:
        do:
          io.cloudslang.microfocus.oo.designer.content-pack.unassign_cp:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - cp_id: '${cp_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: has_any_failure
    - remove_cp:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(release_binary_url) > 0)}'
        navigate:
          - 'TRUE': unassign_cp
          - 'FALSE': has_any_failure
    - get_repo_details:
        do:
          io.cloudslang.microfocus.oo.designer.repository.get_repo_details:
            - ws_id: '${ws_id}'
        publish:
          - repo_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: does_repo_exist
    - does_repo_exist:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(repo_id)>0)}'
        navigate:
          - 'TRUE': update_repo
          - 'FALSE': import_repo
    - update_repo:
        do:
          io.cloudslang.microfocus.oo.designer.repository.update_repo:
            - token: '${token}'
            - repo_id: '${repo_id}'
        publish:
          - status_json
        navigate:
          - FAILURE: update_repo_failed
          - SUCCESS: remove_cp
    - import_cp_failed:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
        publish:
          - failure: import_cp
        navigate:
          - SUCCESS: get_repo_details
          - FAILURE: on_failure
    - import_repo_failed:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
        publish:
          - failure: '${("" if failure == "" else failure+",")+"import_repo"}'
        navigate:
          - SUCCESS: remove_cp
          - FAILURE: on_failure
    - update_repo_failed:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
        publish:
          - failure: '${("" if failure == "" else failure+",")+"update_repo"}'
        navigate:
          - SUCCESS: remove_cp
          - FAILURE: on_failure
    - has_any_failure:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(failure)>0)}'
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': SUCCESS
  outputs:
    - status_json: '${status_json}'
    - failure: '${failure}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      unassign_cp:
        x: 864
        'y': 417
      update_repo:
        x: 724
        'y': 82
      remove_cp:
        x: 727
        'y': 299
      get_github_repo_details:
        x: 40
        'y': 87
      import_latest_release:
        x: 41
        'y': 303
      import_repo:
        x: 470
        'y': 299
      import_repo_failed:
        x: 594
        'y': 417
      does_repo_exist:
        x: 469
        'y': 83
      has_any_failure:
        x: 863
        'y': 196
        navigate:
          93d3296f-3799-c556-47fe-ac5fcfbaf453:
            targetId: 45417b61-6025-9c8f-7297-4b7e868f4077
            port: 'TRUE'
          b3ea8f3a-dbc1-0f1a-c66d-0add0c3b9a22:
            targetId: 02a1a501-c474-69f5-d4dd-21bdeaac9ab0
            port: 'FALSE'
      import_cp_from_url:
        x: 232
        'y': 306
      update_repo_failed:
        x: 590
        'y': 193
      import_cp_failed:
        x: 372
        'y': 193
      get_repo_details:
        x: 233
        'y': 86
    results:
      SUCCESS:
        02a1a501-c474-69f5-d4dd-21bdeaac9ab0:
          x: 959
          'y': 78
      FAILURE:
        45417b61-6025-9c8f-7297-4b7e868f4077:
          x: 967
          'y': 307
