########################################################################################################################
#!!
#! @description: Escapes the given string to be valid in a JSON document; or vice versa - takes the JSON document and unescapes it back to a common string.
#!
#! @input input_string: The piece of string to escaped/unescaped
#! @input escape: If false, it unescapes the given string; otherwise it escapes the given string
#!
#! @output output_string: The resulting escaped/unescaped input_string
#! @output failure: Error message in case of failure
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.base.json
operation:
  name: escape_json
  inputs:
    - input_string
    - escape:
        private: false
        required: false
  python_action:
    script: |-
      import json, sys
      try:
          if escape == 'false':   #unescape
              output_string = json.loads(input_string).encode('utf-8')
          else:                   #escape
              output_string = json.dumps(input_string)
          failure = ''
      except Exception as e:
          failure =  ','.join([str(x) for x in sys.exc_info()])
  outputs:
    - output_string
    - failure
  results:
    - SUCCESS: '${len(failure) == 0}'
    - FAILURE
