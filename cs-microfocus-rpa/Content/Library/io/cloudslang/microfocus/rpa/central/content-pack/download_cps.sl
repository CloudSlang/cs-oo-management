########################################################################################################################
#!!
#! @description: Downloads all Content Packs from Central to the given folder. The flow tries to download rest of CPs even when a CP download fails. It gives the list of failed CP downloads once it finishes. The flow fails when at least one CP download fails.
#!
#! @input cps_folder: Folder where to download the Content Packs; any existing file having the same name as the CP being downloaded will be overwritten
#!
#! @output failed_cps: List of Content Packs whose download has failed or empty if nothing has failed
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.central.content-pack
flow:
  name: download_cps
  inputs:
    - cps_folder
  workflow:
    - get_cps:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.get_cps: []
        publish:
          - cps_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_cp_ids
    - download_cp:
        do:
          io.cloudslang.microfocus.rpa.central.content-pack.download_cp:
            - cp_id: '${cp_id}'
            - cp_file: "${cps_folder+'/'+cp_name+'-'+cp_version+'.jar'}"
        navigate:
          - FAILURE: mark_failed_cp
          - SUCCESS: list_iterator
    - get_cp_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: '$.*.id'
        publish:
          - cp_ids: '${return_result[1:-1]}'
          - failed_cps: ''
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${cp_ids}'
        publish:
          - cp_id: '${result_string[1:-1]}'
        navigate:
          - HAS_MORE: get_cp_name
          - NO_MORE: has_any_cp_download_failed
          - FAILURE: on_failure
    - get_cp_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${'$.[?(@.id == \"%s\")].name' % cp_id}"
        publish:
          - cp_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_cp_version
          - FAILURE: on_failure
    - get_cp_version:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${cps_json}'
            - json_path: "${'$.[?(@.id == \"%s\")].version' % cp_id}"
        publish:
          - cp_version: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: download_cp
          - FAILURE: on_failure
    - mark_failed_cp:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
            - failed_cps_in: '${failed_cps}'
            - cp_name: '${cp_name}'
            - cp_version: '${cp_version}'
        publish:
          - failed_cps: "${failed_cps_in+cp_name+'-'+cp_version+'.jar,'}"
        navigate:
          - SUCCESS: delete
          - FAILURE: on_failure
    - has_any_cp_download_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(failed_cps)>0)}'
            - failed_cps_in: '${failed_cps}'
        publish:
          - failed_cps: '${failed_cps_in if len(failed_cps_in) == 0 else failed_cps_in[0:-1]}'
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': SUCCESS
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: "${cps_folder+'/'+cp_name+'-'+cp_version+'.jar'}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: list_iterator
  outputs:
    - failed_cps: '${failed_cps}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      download_cp:
        x: 413
        'y': 559
      delete:
        x: 202
        'y': 271
      get_cp_ids:
        x: 229
        'y': 96
      list_iterator:
        x: 414
        'y': 94
      get_cp_version:
        x: 571
        'y': 444
      get_cp_name:
        x: 637
        'y': 265
      has_any_cp_download_failed:
        x: 625
        'y': 96
        navigate:
          07d728f4-22f0-5be6-1607-b6e27c76ed99:
            targetId: c590fd92-5251-a6a3-b93c-6b1a28e72846
            port: 'FALSE'
          049631e8-d031-5096-3d2c-9ee84dc03af4:
            targetId: dd92915b-f13f-ee2b-0eb2-afd8fe693a11
            port: 'TRUE'
      mark_failed_cp:
        x: 229
        'y': 438
      get_cps:
        x: 49
        'y': 94
    results:
      SUCCESS:
        c590fd92-5251-a6a3-b93c-6b1a28e72846:
          x: 852
          'y': 99
      FAILURE:
        dd92915b-f13f-ee2b-0eb2-afd8fe693a11:
          x: 842
          'y': 312
