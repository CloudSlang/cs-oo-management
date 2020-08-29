########################################################################################################################
#!!
#! @description: Deploys all the CPs from the given folder. One can also force the order of the first CPs to be deployed and the list of the last CPs to be deployed.
#!
#! @input cps_folder: Folder from which to deploy the CPs
#! @input first: List of CP names to be deployed as the first ones; do not use brackets, use only CP names (no versions, no spaces); cp1,cp2,cp3
#! @input last: List of CP names to be deployed as the last ones; do not use brackets, use only CP names (no versions, no spaces); cp1,cp2,cp3
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: deploy_cps
  inputs:
    - cps_folder: 'C:/Users/Administrator/Downloads/content-packs'
    - first:
        default: 'cs-base-cp,oo10-base-cp,cs-tesseract-ocr-cp,oo-microsoft-office-365-cp,cs-microsoft-office365-cp,oo-microfocus-solutions-cp,oo10-virtualization-cp,oo10-middleware-cp,oo10-sm-cp'
        required: false
    - last:
        default: 'AOS-cp,Salesforce-cp,SAP-cp'
        required: false
  workflow:
    - list_files:
        do:
          io.cloudslang.base.filesystem.list_files:
            - pattern: "${cps_folder+'/*.jar'}"
            - full_path: 'false'
        publish:
          - files
        navigate:
          - SUCCESS: sort_cps
    - import_cp:
        loop:
          for: cp_file in eval(sorted_cps)
          do:
            io.cloudslang.microfocus.rpa.central.content-pack.import_cp:
              - cp_file: "${cps_folder+'/'+cp_file}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - sort_cps:
        do:
          io.cloudslang.microfocus.rpa.demo.sub_flows.sort_cps:
            - cps: '${files}'
            - first: '${first}'
            - last: '${last}'
        publish:
          - sorted_cps
        navigate:
          - SUCCESS: import_cp
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_files:
        x: 96
        'y': 89
      import_cp:
        x: 333
        'y': 91
        navigate:
          138956ba-7be1-759a-2077-b3a395c31c3d:
            targetId: c27a7ff7-2d65-704d-0c54-444c4f8ff3a9
            port: SUCCESS
      sort_cps:
        x: 214
        'y': 94
    results:
      SUCCESS:
        c27a7ff7-2d65-704d-0c54-444c4f8ff3a9:
          x: 486
          'y': 98
