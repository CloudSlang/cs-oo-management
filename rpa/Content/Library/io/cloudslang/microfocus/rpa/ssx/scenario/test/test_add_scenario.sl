namespace: io.cloudslang.microfocus.rpa.ssx.scenario.test
flow:
  name: test_add_scenario
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.ssx.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_scenario
    - add_scenario:
        do:
          io.cloudslang.microfocus.rpa.ssx.scenario.add_scenario:
            - token: '${token}'
            - category_id: '5'
            - scenario_json: "${'''{\n   \"categoryId\":\"%s\",\n   \"name\":\"CREATE USERS FROM EXCEL4\",\n   \"description\":\"Creates up to 1000 SAP users from given excel sheet. The sheet must have a header where each property is written in one column. Name (containing the first name and the last name) is in a single column; the names must be delimited by a white space character.\",\n   \"flowVo\":{\n      \"flowPath\":\"Library/SAP/user/bulk/create_users_from_excel.sl\",\n      \"flowUuid\":\"SAP.user.bulk.create_users_from_excel\",\n      \"timeoutValue\":0\n   },\n   \"inputs\":[\n      {\n         \"defaultValue\":\"C:\\\\\\\\Enablement\\\\\\\\HotLabs\\\\\\\\SAP\\\\\\\\Emails_Accounts.xlsx\",\n         \"label\":\"excel_file\",\n         \"originalName\":\"excel_file\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"Environment\",\n         \"label\":\"worksheet_name\",\n         \"originalName\":\"worksheet_name\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"SAP User\",\n         \"label\":\"username_header\",\n         \"originalName\":\"username_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"SAP Password\",\n         \"label\":\"password_header\",\n         \"originalName\":\"password_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"Name\",\n         \"label\":\"name_header\",\n         \"originalName\":\"name_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"E-mail\",\n         \"label\":\"email_header\",\n         \"originalName\":\"email_header\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      },\n      {\n         \"defaultValue\":\"true\",\n         \"label\":\"set_admin\",\n         \"originalName\":\"set_admin\",\n         \"type\":\"STRING\",\n         \"required\":true,\n         \"exposed\":true,\n         \"sources\":null,\n         \"separator\":null\n      }\n   ],\n   \"outputs\":[\n\n   ],\n   \"roles\":[\n      \"ADMINISTRATOR\",\n      \"PROMOTER\"\n   ]\n}'''}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_scenario:
        x: 214
        'y': 144
        navigate:
          a82bc575-f297-1349-1a76-792f3200be39:
            targetId: d1230ac0-3a26-69c9-524a-5a9ef32db2a5
            port: SUCCESS
      get_token:
        x: 51
        'y': 141
    results:
      SUCCESS:
        d1230ac0-3a26-69c9-524a-5a9ef32db2a5:
          x: 372
          'y': 140
