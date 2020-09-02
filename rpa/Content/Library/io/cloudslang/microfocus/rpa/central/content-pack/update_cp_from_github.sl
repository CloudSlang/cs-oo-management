########################################################################################################################
#!!
#! @description: Imports the GitHub repository but before that, it imports the latest release attached to the repository and also removes this imported CP from the workspace. This was possible binary artifacts (RPA activities) will get updated in the library of binaries.
#!
#! @input github_repo: Git Hub repo owner/name of a repo to be imported
#! @input cp_folder: If given, the downloaded binaries will be stored permanently in this folder (otherwise donwloaded temporarily and removed after import)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.content-pack
flow:
  name: update_cp_from_github
  inputs:
    - github_repo
    - cp_folder:
        required: false
  workflow:
    - get_repo_details:
        do:
          io.cloudslang.base.github.get_repo_details:
            - owner: "${github_repo.split('/')[0]}"
            - repo: "${github_repo.split('/')[1]}"
            - update_binaries: '${update_binaries}'
        publish:
          - clone_url
          - release_binary_url
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_binaries_available
          - NO_RELEASE: NOTHING_TO_UPDATE
    - is_binaries_available:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(release_binary_url) > 0)}'
        navigate:
          - 'TRUE': update_cp_from_url
          - 'FALSE': NOTHING_TO_UPDATE
    - update_cp_from_url:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.update_cp_from_url:
            - cp_url: '${release_binary_url}'
            - cp_folder: '${cp_folder}'
        publish:
          - cp_name
          - cp_version
          - updated
        navigate:
          - FAILURE: on_failure
          - ALREADY_DEPLOYED: ALREADY_DEPLOYED
          - SUCCESS: SUCCESS
  outputs:
    - status_json: '${status_json}'
    - cp_name: '${cp_name}'
    - cp_version: '${cp_version}'
    - updated: '${updated}'
  results:
    - FAILURE
    - NOTHING_TO_UPDATE
    - ALREADY_DEPLOYED
    - SUCCESS
extensions:
  graph:
    steps:
      get_repo_details:
        x: 69
        'y': 87
        navigate:
          30c4dec1-76ee-f461-6214-c5bd0149cc3a:
            targetId: 68b89844-8a5b-103f-ef0f-af7dba3b322e
            port: NO_RELEASE
      update_cp_from_url:
        x: 362
        'y': 301
        navigate:
          62cdda39-54e8-c9c7-920a-a68d560c253f:
            targetId: 28bef853-7165-9183-01e5-4d2c9d4cf705
            port: ALREADY_DEPLOYED
          0865c65e-3595-5dbc-e693-5331dd8a19d3:
            targetId: 108cb675-6ca2-3caf-9d00-ab8265ca068c
            port: SUCCESS
      is_binaries_available:
        x: 68
        'y': 300
        navigate:
          0384311c-cc73-620d-09ad-cb590c0e2dd4:
            targetId: 68b89844-8a5b-103f-ef0f-af7dba3b322e
            port: 'FALSE'
    results:
      NOTHING_TO_UPDATE:
        68b89844-8a5b-103f-ef0f-af7dba3b322e:
          x: 365
          'y': 88
      ALREADY_DEPLOYED:
        28bef853-7165-9183-01e5-4d2c9d4cf705:
          x: 610
          'y': 89
      SUCCESS:
        108cb675-6ca2-3caf-9d00-ab8265ca068c:
          x: 615
          'y': 303
