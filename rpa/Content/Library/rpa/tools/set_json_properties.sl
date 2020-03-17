########################################################################################################################
#!!
#! @description: Sets top or second level properties in json document and returns the new document.
#!
#! @input properties: List of properties to be set; if the name contains a dot '.', it will set the property on the second level
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
        default: ','
  python_action:
    script: "import json\ndata = json.loads(json_string)\n\nfor property, value in zip(properties.split(delimiter), values.split(delimiter)):\n    if '.' in property:\n        parent = property.split('.')[0]\n        child = property.split('.')[1]\n        if (data[parent] == None):\n            data[parent] = {}\n        data[parent][child] = value\n    else:    \n        data[property] = value\n\nresult_json = json.dumps(data)"
  outputs:
    - result_json: '${result_json}'
  results:
    - SUCCESS
