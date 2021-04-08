########################################################################################################################
#!!
#! @description: Sets top level or second level properties in a JSON document and returns the new document.
#!
#! @input json_string: The original JSON document
#! @input properties: List of properties to be set; if the name contains a dot '.', it will set the property on the second level
#! @input values: List of values of the properties; must be of the same length as the properties list
#! @input delimiter: Delimiter of properties/values in the lists (default is any whitespace)
#! @input evaluate: If set to true, evaluate the values before adding into the JSON document (good for complex structures). The values input is split by delimiter before evaluating each item in the values list; use an unused string if not wanting to split the evaluated value.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.base.json
operation:
  name: set_json_properties
  inputs:
    - json_string
    - properties
    - values
    - delimiter:
        required: false
        default: ','
    - evaluate:
        required: false
  python_action:
    script: "import json\ndata = json.loads(json_string)\n\nfor property, value in zip(properties.split(delimiter), values.split(delimiter)):\n    real_value = eval(value) if evaluate == 'true' else value\n    if '.' in property:\n        parent = property.split('.')[0]\n        child = property.split('.')[1]\n        if (data[parent] == None):\n            data[parent] = {}\n        data[parent][child] = real_value\n    else:    \n        data[property] = real_value\n\nresult_json = json.dumps(data)"
  outputs:
    - result_json: '${result_json}'
  results:
    - SUCCESS
