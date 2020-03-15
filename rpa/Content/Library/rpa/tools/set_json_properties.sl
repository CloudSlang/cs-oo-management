########################################################################################################################
#!!
#! @description: Sets top level properties in json document and returns the new document.
#!
#! @input properties: List of properties to be set
#! @input values: List of values of the properties; must be of the same length as properties
#! @input delimiter: Delimiter of properties/values in the lists
#!!#
########################################################################################################################
namespace: rpa.tools
operation:
  name: set_json_properties
  inputs:
    - json_string
    - properties
    - values
    - delimiter:
        required: false
  python_action:
    script: |-
      import json
      data = json.loads(json_string)

      for property, value in zip(properties.split(delimiter), values.split(delimiter)):
          data[property] = value

      result_json = json.dumps(data)
  outputs:
    - result_json: '${result_json}'
  results:
    - SUCCESS
