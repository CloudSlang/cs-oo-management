########################################################################################################################
#!!
#! @description: Retrieves the current time in millis.
#!
#! @output time_millis: Current time in millis
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.base.datetime
operation:
  name: get_millis
  python_action:
    script: |-
      import time
      time_millis = str(long(time.time() * 1000))
  outputs:
    - time_millis: '${time_millis}'
  results:
    - SUCCESS

