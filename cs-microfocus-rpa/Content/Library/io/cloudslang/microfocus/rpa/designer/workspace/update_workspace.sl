########################################################################################################################
#!!
#! @description: Pulls changes in Git repository and also updates the binaries if attached to the repo. It can also resolve the repo pull failures by reimporting the SCM repo.
#!
#! @input ws_id: Workspace ID
#! @input cp_folder: If given, the downloaded binaries will be stored permanently in this folder (otherwise downloaded temporarily and removed after import)
#! @input repo_failure_resolution: How to resolve repository update failure; RESET = remove the repo and import it again; NONE = do not resolve, this flow will fail
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
    - repo_failure_resolution:
        default: RESET
        required: true
  workflow:
    - get_repo_details:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.get_repo_details:
            - ws_id: '${ws_id}'
        publish:
          - scm_url
          - repo_owner: '${"" if scm_url == "" else scm_url.split("/")[-2]}'
          - repo_name
          - repo_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_scm_repository
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
          - FAILURE: string_equals
          - SUCCESS: SUCCESS
    - is_scm_repository:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(repo_id)>0)}'
        navigate:
          - 'TRUE': update_repo_binaries
          - 'FALSE': NO_SCM_REPOSITORY
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${repo_failure_resolution}'
            - second_string: RESET
        navigate:
          - SUCCESS: delete_repo
          - FAILURE: on_failure
    - delete_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.delete_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - repo_id: '${repo_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: import_repo
    - import_repo:
        do:
          io.cloudslang.microfocus.rpa.designer.repository.import_repo:
            - token: '${token}'
            - ws_id: '${ws_id}'
            - scm_url: '${scm_url}'
        publish:
          - status_json
          - host_json
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
    - NO_SCM_REPOSITORY
extensions:
  graph:
    steps:
      get_repo_details:
        x: 107
        'y': 108
      update_repo_binaries:
        x: 294
        'y': 109
      update_repo:
        x: 485
        'y': 109
        navigate:
          62dc77fe-6e66-cc5f-e7c7-adbbf8daf4f6:
            targetId: 7f1cba12-de4d-8c26-8df7-5dea2c79b1ad
            port: SUCCESS
      is_scm_repository:
        x: 104
        'y': 298
        navigate:
          2bded813-c709-a437-1cdf-e4af2b0f5ed3:
            targetId: d4fc94e3-58db-e7bf-c319-f0e4e2db266c
            port: 'FALSE'
      string_equals:
        x: 482
        'y': 295
      delete_repo:
        x: 674
        'y': 294
      import_repo:
        x: 854
        'y': 295
        navigate:
          015946ed-4d7e-e2e8-ee30-b71cab1c90f7:
            targetId: 7f1cba12-de4d-8c26-8df7-5dea2c79b1ad
            port: SUCCESS
    results:
      SUCCESS:
        7f1cba12-de4d-8c26-8df7-5dea2c79b1ad:
          x: 673
          'y': 111
      NO_SCM_REPOSITORY:
        d4fc94e3-58db-e7bf-c319-f0e4e2db266c:
          x: 300
          'y': 297
