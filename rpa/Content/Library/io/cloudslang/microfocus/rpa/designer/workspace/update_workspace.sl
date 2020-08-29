########################################################################################################################
#!!
#! @description: Pulls changes in Git repository and also updates the binaries if attached to the repo.
#!
#! @input cp_folder: If given, the downloaded binaries will be stored permanently in this folder (otherwise downloaded temporarily and removed after import)
#!
#! @output process_status: RUNNING, PENDING, FINISHED
#! @output status_json: JSON of the SCM pull process status
#! @output binaries_status_json: JSON of the binaries upload status
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.designer.workspace
flow:
  name: update_workspace
  inputs:
    - token
    - ws_id
    - cp_folder:
        required: false
  workflow:
    - get_repo_details:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.get_repo_details:
            - ws_id: '${ws_id}'
        publish:
          - scm_url
          - repo_owner: '${scm_url.split("/")[-2]}'
          - repo_name: "${scm_url.split(\"/\")[-1][0:-4] if scm_url.endswith('.git') else scm_url.split(\"/\")[-1]}"
          - repo_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_repo_binaries
    - update_repo_binaries:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.update_repo_binaries:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - github_repo: '${repo_owner+"/"+repo_name}'
            - cp_folder: '${cp_folder}'
        publish:
          - binaries_status_json: '${status_json}'
        navigate:
          - SUCCESS: update_repo
          - FAILURE: on_failure
          - NO_BINARIES: update_repo
    - update_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.update_repo:
            - token: '${token}'
            - repo_id: '${repo_id}'
        publish:
          - process_json
          - process_id
          - status_json
          - process_status
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - process_status: '${process_status}'
    - status_json: '${status_json}'
    - binaries_status_json: '${binaries_status_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_repo_details:
        x: 107
        'y': 108
      update_repo_binaries:
        x: 294
        'y': 110
      update_repo:
        x: 485
        'y': 117
        navigate:
          62dc77fe-6e66-cc5f-e7c7-adbbf8daf4f6:
            targetId: 7f1cba12-de4d-8c26-8df7-5dea2c79b1ad
            port: SUCCESS
    results:
      SUCCESS:
        7f1cba12-de4d-8c26-8df7-5dea2c79b1ad:
          x: 673
          'y': 111
