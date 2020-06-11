########################################################################################################################
#!!
#! @description: Retrieves the current time in millis.
#!!#
########################################################################################################################
namespace: rpa.tools.time
operation:
  name: get_time
  python_action:
    use_jython: false
    script: "import time\ndef execute(): \n    return {'time_millis' : str(round(time.time() * 1000)) }"
  outputs:
    - time_millis: '${time_millis}'
  results:
    - SUCCESS
