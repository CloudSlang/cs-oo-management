########################################################################################################################
#!!
#! @description: Sorts the list of CPs so the first ones are first in the list and last ones are last in the list.
#!
#! @input cps: List of CP files to be sorted; ['cp1-ver.jar', 'cp2-ver.jar', ... ]
#! @input first: List of CP names to be deployed as the first ones; do not use brackets, use only CP names (no versions, no spaces); cp1,cp2,cp3
#! @input last: List of CP names to be deployed as the last ones; do not use brackets, use only CP names (no versions, no spaces); cp1,cp2,cp3
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo.sub_flows
operation:
  name: sort_cps
  inputs:
    - cps
    - first:
        required: false
    - last:
        required: false
  python_action:
    use_jython: false
    script: "def get_cp_name(cp_name):   # returns the name of the CP (cuts the CP version)\n  return cp_name.rsplit('-', 1)[0]\n\ndef execute(cps, first, last): \n    input_list = eval(cps)\n    first_list = [] if first is None else first.split(\",\")\n    last_list = [] if last is None else last.split(\",\")\n\n    def major_cps_first(item):\n      item = get_cp_name(item)\n      if item in first_list:\n        return first.index(item)-1000\n      if item in last_list:\n        return last.index(item)+1000\n      return 0;   \n\n    sorted_list = sorted(input_list, key=major_cps_first)\n    return {\"sorted_cps\" : str(sorted_list) }"
  outputs:
    - sorted_cps: '${sorted_cps}'
  results:
    - SUCCESS
