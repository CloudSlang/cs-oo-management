#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Transforms the JSON document describing the workspace content to another JSON document. The resulting document contains a list of projects; in each project it lists all folders and files (flows, operations and properties) the project consists of.
#!
#! @input projects_json: JSON document describing the workspace content
#!
#! @output projects_details: List of projects with a list of flows/operations/properties the project consists of (as files)
#! @output failure: Error message in case of error
#!
#! @result SUCCESS: 
#!!#
########################################################################################################################

namespace: io.cloudslang.microfocus.rpa.designer.project
operation:
  name: get_projects_details
  inputs:
    - projects_json
  python_action:
    script: "import json\n\ntry:\n    projects = json.loads(projects_json)\n    projects_p = []\n\n    for project in projects:\n        folders = []\n        flows = []\n        operations = []\n        properties = []\n\n        id = int(project.get('id'))\n        name = project.get('text')\n        children = project.get('children')\n\n        queue = []\n        if children is not None:\n            queue.append({'parent' : name, 'children' : children})\n                \n        folders.append(name)                            # project is also a folder        \n        while len(queue) > 0:\n            element = queue.pop();\n            parent = element.get('parent')\n            children = element.get('children')\n            for child in children:\n                child_name = child.get('text')\n                me = parent + '/' + child_name\n                children = child.get('children')\n                type = child.get('type')\n                if type.endswith('FOLDER'):             #LIBRARY_FOLDER, CONFIGURATION_FOLDER, SYSTEM_PROP_ROOT_FOLDER, SYSTEM_PROP_FOLDER, FOLDER\n                    folders.append(me)\n                else:\n                    id = int(child.get('id'))\n                    path = me+'.sl'\n                    if type.endswith('FLOW'):\n                        flows.append({'id' : id, 'path' : path})\n                    elif type.endswith('OPERATION'):    #PYTHON_OPERATION\n                        operations.append({'id' : id, 'path' : path})\n                    elif type.endswith('PROPERTY'):     #SYSTEM_PROPERTY \n                        properties.append({'id' : id, 'path' : path})\n                if children is not None:\n                    queue.append({'parent' : me, 'children':children})\n        projects_p.append({\n            'id' : id, \n            'name' : name,\n            'folders' : folders,\n            'flows' : flows,\n            'operations' : operations,\n            'properties' : properties\n        })    \n\n    projects_details = json.dumps(projects_p)\n    failure = ''    \nexcept Exception as e:\n    failure = \"%s: %s\" % (type(e).__name__, str(e))"
  outputs:
    - projects_details
    - failure
  results:
    - SUCCESS: '${len(failure) == 0}'
    - FAILURE
