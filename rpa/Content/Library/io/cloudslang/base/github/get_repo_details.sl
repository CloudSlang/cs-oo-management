########################################################################################################################
#!!
#! @description: Receives public GitHub repository details.
#!
#! @output clone_url: URL to clone the repo
#! @output release_binary_url: URL to download the latest release binary
#!
#! @result SUCCESS: If the repo has a release; the latest is returned
#! @result NO_RELEASE: If the repo has no releases
#!!#
########################################################################################################################
namespace: io.cloudslang.base.github
flow:
  name: get_repo_details
  inputs:
    - owner: pe-pan
    - repo: rpa-rpa
  workflow:
    - get_repo_details:
        do:
          io.cloudslang.base.github._operations.github_http_action:
            - url: "${'/repos/%s/%s' % (owner, repo)}"
            - method: GET
        publish:
          - repo_json: '${return_result}'
          - repo_pton: "${return_result.replace(\":null\", \":None\").replace(':false', ':False').replace(':true', ':True')}"
          - clone_url: "${eval(repo_pton).get('clone_url','')}"
          - releases_url: "${eval(repo_pton).get('releases_url','')}"
          - latest_release_url: '${releases_url.replace("{/id}","/latest")}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_releases
    - get_latest_release:
        do:
          io.cloudslang.base.github._operations.github_http_action:
            - url: "${'/repos/%s/%s/releases/latest' % (owner, repo)}"
            - method: GET
        publish:
          - latest_release_json: '${return_result}'
          - latest_release_pton: "${return_result.replace(\":null\", \":None\").replace(':false', ':False').replace(':true', ':True')}"
          - release_binary_url: "${eval(latest_release_pton).get('assets','[{\"browser_download_url\":\"\"}]')[0].get('browser_download_url','')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_releases:
        do:
          io.cloudslang.base.github._operations.github_http_action:
            - url: "${'/repos/%s/%s/releases' % (owner, repo)}"
            - method: GET
        publish:
          - releases_pton: "${return_result.replace(\":null\", \":None\").replace(':false', ':False').replace(':true', ':True')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_there_release
    - is_there_release:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(eval(releases_pton)) > 0)}'
        navigate:
          - 'TRUE': get_latest_release
          - 'FALSE': NO_RELEASE
  outputs:
    - repo_json: '${repo_json}'
    - latest_release_json: '${latest_release_json}'
    - clone_url: '${clone_url}'
    - release_binary_url: '${release_binary_url}'
  results:
    - FAILURE
    - SUCCESS
    - NO_RELEASE
extensions:
  graph:
    steps:
      get_repo_details:
        x: 59
        'y': 88
      get_latest_release:
        x: 418
        'y': 287
        navigate:
          1950db13-8e38-cca8-20ff-9c8ec7a0a5c1:
            targetId: 6e1c8a19-e1dc-0d56-63c7-a9598d21819d
            port: SUCCESS
      get_releases:
        x: 227
        'y': 87
      is_there_release:
        x: 226
        'y': 285
        navigate:
          2ab45646-bfd7-be70-5c34-d861c6778870:
            targetId: ca58a08a-fcfe-6f09-7b70-6d2c4eb1ef84
            port: 'FALSE'
    results:
      SUCCESS:
        6e1c8a19-e1dc-0d56-63c7-a9598d21819d:
          x: 414
          'y': 87
      NO_RELEASE:
        ca58a08a-fcfe-6f09-7b70-6d2c4eb1ef84:
          x: 51
          'y': 288
