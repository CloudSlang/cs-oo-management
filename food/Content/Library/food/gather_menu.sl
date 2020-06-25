namespace: food
operation:
  name: gather_menu
  sequential_action:
    gav: com.microfocus.seq:food.gather_menu:1.0.0
    skills:
    - Web
    settings:
      windows:
        active: false
      web:
        active: true
        address: https://www.menicka.cz/
        close_on_exit: true
    steps:
    - step:
        id: '1'
        object_path: Browser("Restaurace, obědy, polední").Page("Restaurace, obědy,
          polední").WebEdit("search")
        action: Set
        default_args: '"u provaznice"'
        snapshot: .\Snapshots\ssf1.html
        highlight_id: Browser("Restaurace, obědy, polední").Page("Restaurace, obědy,
          polední").WebEdit("search")
    - step:
        id: '2'
        object_path: Browser("Restaurace, obědy, polední").Page("Restaurace, obědy,
          polední").Link("Hledat")
        action: Click
        snapshot: .\Snapshots\ssf2.html
        highlight_id: Browser("Restaurace, obědy, polední").Page("Restaurace, obědy,
          polední").Link("Hledat")
    - step:
        id: '3'
        object_path: 'Browser("Restaurace, obědy, polední").Page("U Provaznice v Praze
          1,").WebElement("Menu: 11:00 – 15:00Čtvrtek")'
        action: Output
        default_args: CheckPoint("menu")
    - step:
        id: '4'
        object_path: Browser("Restaurace, obědy, polední").Page("U Provaznice v Praze
          1,").WebElement("Čtvrtek 25.6.2020")
        action: Output
        default_args: CheckPoint("day")
    - step:
        id: '5'
        object_path: Browser("Restaurace, obědy, polední").Page("U Provaznice v Praze
          1,").WebElement("1. Vepřová pečeně na houbách,")
        action: Output
        default_args: CheckPoint("food")
  outputs:
  - menu:
      robot: true
      value: ${menu}
  - day:
      robot: true
      value: ${day}
  - food:
      robot: true
      value: ${food}
  - return_result: ${return_result}
  - error_message: ${error_message}
  results:
  - SUCCESS
  - WARNING
  - FAILURE
object_repository:
  objects:
  - object:
      class: Browser
      name: Restaurace, obědy, polední
      properties:
      - property:
          value:
            value: Restaurace, obědy, polední a denní menu v Praze 1 | Meníčka.cz
            regular_expression: false
          name: title
          hidden: true
          read_only: true
          type: STRING
      - property:
          value:
            value: https://www.menicka.cz/praha-1.html?fto=true
            regular_expression: false
          name: openurl
          hidden: true
          read_only: true
          type: STRING
      - property:
          value:
            value: Restaurace, obědy, polední a denní menu v Praze 1 | Meníčka.cz
            regular_expression: false
          name: opentitle
          hidden: true
          read_only: true
          type: STRING
      - property:
          value:
            value: '-1'
            regular_expression: false
          name: openedbytestingtool
          hidden: true
          read_only: true
          type: BOOL
      - property:
          value:
            value: '1'
            regular_expression: false
          name: number of tabs
          hidden: true
          read_only: true
          type: NUMBER
      - property:
          value:
            value: Restaurace, obědy, polední a denní menu v Praze 1 | Meníčka.cz
            regular_expression: false
          name: name
          hidden: true
          read_only: true
          type: STRING
      - property:
          value:
            value: Browser
            regular_expression: false
          name: micclass
          hidden: true
          read_only: true
          type: STRING
      - property:
          value:
            value: '-1'
            regular_expression: false
          name: hastoolbar
          hidden: true
          read_only: true
          type: BOOL
      - property:
          value:
            value: '0'
            regular_expression: false
          name: hasstatusbar
          hidden: true
          read_only: true
          type: BOOL
      - property:
          value:
            value: '-1'
            regular_expression: false
          name: hasmenubar
          hidden: true
          read_only: true
          type: BOOL
      - property:
          value:
            value: '2'
            regular_expression: false
          name: browserindex
          hidden: true
          read_only: true
          type: I2
      basic_identification:
        property_ref:
        - micclass
        ordinal_identifier:
          value: 5
          type: creationtime
      smart_identification:
        base_filter:
          property_ref:
          - micclass
        optional_filter:
          property_ref:
          - name
          - title
          - openurl
          - opentitle
          - hasstatusbar
          - hasmenubar
          - hastoolbar
          - openedbytestingtool
          - number of tabs
        algorithm: Mercury.TolerantPriority
        active: true
      custom_replay: ''
      comments: ''
      visual_relations: ''
      last_update_time: Thursday, June 25, 2020 9:37:36 AM
      child_objects:
      - object:
          class: Page
          name: U Provaznice v Praze 1,
          properties:
          - property:
              value:
                value: ''
                regular_expression: false
              name: user-input in post data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: ''
                regular_expression: false
              name: user input in get data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: https://www.menicka.cz/1837-u-provaznice.html
                regular_expression: false
              name: url without form data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: https://www.menicka.cz/1837-u-provaznice.html
                regular_expression: false
              name: url
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: U Provaznice v Praze 1, obědy, obědové menu, polední menu a
                  meníčka | Meníčka.cz
                regular_expression: false
              name: title
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: ''
                regular_expression: false
              name: non user-input in post data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: ''
                regular_expression: false
              name: non user-input in get data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: Page
                regular_expression: false
              name: micclass
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: '20084'
                regular_expression: false
              name: index
              hidden: true
              read_only: true
              type: NUMBER
          - property:
              value:
                value: ''
                regular_expression: false
              name: form data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: '53486'
                regular_expression: false
              name: document size
              hidden: true
              read_only: true
              type: NUMBER
          - property:
              value:
                value: ''
                regular_expression: false
              name: all data in get method
              hidden: true
              read_only: true
              type: STRING
          basic_identification:
            property_ref:
            - micclass
            ordinal_identifier: ''
          smart_identification:
            base_filter:
              property_ref:
              - micclass
            optional_filter:
              property_ref:
              - title
              - url
            algorithm: Mercury.TolerantPriority
            active: true
          custom_replay: ''
          comments: ''
          visual_relations: ''
          last_update_time: Thursday, June 25, 2020 9:37:36 AM
          child_objects:
          - object:
              class: WebElement
              name: Čtvrtek 25.6.2020
              properties:
              - property:
                  value:
                    value: '-1'
                    regular_expression: false
                  name: visible
                  hidden: true
                  read_only: true
                  type: BOOL
              - property:
                  value:
                    value: '621'
                    regular_expression: false
                  name: source_index
                  hidden: true
                  read_only: true
                  type: NUMBER
              - property:
                  value:
                    value: WebElement
                    regular_expression: false
                  name: micclass
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: Čtvrtek 25.6.2020
                    regular_expression: false
                  name: innertext
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: DIV
                    regular_expression: false
                  name: html tag
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: html id
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: nadpis
                    regular_expression: false
                  name: class
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: acc_name
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: //DIV[@id="menicka"]/DIV[1]/DIV[2]/DIV[1]/DIV[5]/DIV[2]/DIV[2]
                    regular_expression: false
                  name: _xpath
                  hidden: true
                  read_only: true
                  type: STRING
              basic_identification:
                property_ref:
                - micclass
                - innertext
                - html tag
                - _xpath
                ordinal_identifier: ''
              smart_identification:
                base_filter:
                  property_ref:
                  - micclass
                  - html tag
                optional_filter:
                  property_ref:
                  - html id
                  - class
                  - innertext
                  - visible
                  - acc_name
                algorithm: Mercury.TolerantPriority
                active: true
              custom_replay: ''
              comments: ''
              visual_relations: ''
              last_update_time: Thursday, June 25, 2020 9:37:36 AM
              child_objects: []
          - object:
              class: WebElement
              name: 'Menu: 11:00 – 15:00Čtvrtek'
              properties:
              - property:
                  value:
                    value: '-1'
                    regular_expression: false
                  name: visible
                  hidden: true
                  read_only: true
                  type: BOOL
              - property:
                  value:
                    value: '617'
                    regular_expression: false
                  name: source_index
                  hidden: true
                  read_only: true
                  type: NUMBER
              - property:
                  value:
                    value: WebElement
                    regular_expression: false
                  name: micclass
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: 'Menu: 11:00 – 15:00Čtvrtek 25.6.2020Gulášová polévka 138
                      Kč1. Vepřová pečeně na houbách, houskové knedlíky122 Kč2. Marinovaná
                      kuřecí křídla, americké brambory, česnekový dip 1, 7125 Kč3.
                      Farmářský salát s opečenou šunkou, sázeným vejcem a pikantní
                      majonézou 1, 3, 7, 12135 Kč4. Tip krásné Magdalény!!!5. Gulášová
                      polévka, Mix grill (kuřecí prsa, roštěnec, vepřová panenka),
                      mačkané brambory s pečeným česnekem 7139 Kč'
                    regular_expression: false
                  name: innertext
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: DIV
                    regular_expression: false
                  name: html tag
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: html id
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: menicka
                    regular_expression: false
                  name: class
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: acc_name
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: //DIV[@id="menicka"]/DIV[1]/DIV[2]/DIV[1]/DIV[5]/DIV[2]
                    regular_expression: false
                  name: _xpath
                  hidden: true
                  read_only: true
                  type: STRING
              basic_identification:
                property_ref:
                - micclass
                - innertext
                - html tag
                - _xpath
                ordinal_identifier: ''
              smart_identification:
                base_filter:
                  property_ref:
                  - micclass
                  - html tag
                optional_filter:
                  property_ref:
                  - html id
                  - class
                  - innertext
                  - visible
                  - acc_name
                algorithm: Mercury.TolerantPriority
                active: true
              custom_replay: ''
              comments: ''
              visual_relations: ''
              last_update_time: Thursday, June 25, 2020 9:37:36 AM
              child_objects: []
          - object:
              class: WebElement
              name: 1. Vepřová pečeně na houbách,
              properties:
              - property:
                  value:
                    value: '-1'
                    regular_expression: false
                  name: visible
                  hidden: true
                  read_only: true
                  type: BOOL
              - property:
                  value:
                    value: '628'
                    regular_expression: false
                  name: source_index
                  hidden: true
                  read_only: true
                  type: NUMBER
              - property:
                  value:
                    value: WebElement
                    regular_expression: false
                  name: micclass
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: 1. Vepřová pečeně na houbách, houskové knedlíky
                    regular_expression: false
                  name: innertext
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: DIV
                    regular_expression: false
                  name: html tag
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: html id
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: polozka
                    regular_expression: false
                  name: class
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: acc_name
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: //DIV[@id="menicka"]/DIV[1]/DIV[2]/DIV[1]/DIV[5]/DIV[2]/UL[1]/LI[2]/DIV[1]
                    regular_expression: false
                  name: _xpath
                  hidden: true
                  read_only: true
                  type: STRING
              basic_identification:
                property_ref:
                - micclass
                - innertext
                - html tag
                - _xpath
                ordinal_identifier: ''
              smart_identification:
                base_filter:
                  property_ref:
                  - micclass
                  - html tag
                optional_filter:
                  property_ref:
                  - html id
                  - class
                  - innertext
                  - visible
                  - acc_name
                algorithm: Mercury.TolerantPriority
                active: true
              custom_replay: ''
              comments: ''
              visual_relations: ''
              last_update_time: Thursday, June 25, 2020 9:37:36 AM
              child_objects: []
      - object:
          class: Page
          name: Restaurace, obědy, polední
          properties:
          - property:
              value:
                value: ''
                regular_expression: false
              name: user-input in post data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: ''
                regular_expression: false
              name: user input in get data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: https://www.menicka.cz/praha-1.html
                regular_expression: false
              name: url without form data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: https://www.menicka.cz/praha-1.html?fto=true
                regular_expression: false
              name: url
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: Restaurace, obědy, polední a denní menu v Praze 1 | Meníčka.cz
                regular_expression: false
              name: title
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: ''
                regular_expression: false
              name: non user-input in post data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: ''
                regular_expression: false
              name: non user-input in get data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: Page
                regular_expression: false
              name: micclass
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: '20061'
                regular_expression: false
              name: index
              hidden: true
              read_only: true
              type: NUMBER
          - property:
              value:
                value: ''
                regular_expression: false
              name: form data
              hidden: true
              read_only: true
              type: STRING
          - property:
              value:
                value: '401084'
                regular_expression: false
              name: document size
              hidden: true
              read_only: true
              type: NUMBER
          - property:
              value:
                value: ''
                regular_expression: false
              name: all data in get method
              hidden: true
              read_only: true
              type: STRING
          basic_identification:
            property_ref:
            - micclass
            ordinal_identifier: ''
          smart_identification:
            base_filter:
              property_ref:
              - micclass
            optional_filter:
              property_ref:
              - title
              - url
            algorithm: Mercury.TolerantPriority
            active: true
          custom_replay: ''
          comments: ''
          visual_relations: ''
          last_update_time: Thursday, June 25, 2020 9:37:36 AM
          child_objects:
          - object:
              class: WebEdit
              name: search
              properties:
              - property:
                  value:
                    value: WebEdit
                    regular_expression: false
                  name: micclass
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: //INPUT[@id="SearchString"]
                    regular_expression: false
                  name: _xpath
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: search
                    regular_expression: false
                  name: type
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: '436'
                    regular_expression: false
                  name: source_index
                  hidden: true
                  read_only: true
                  type: NUMBER
              - property:
                  value:
                    value: '0'
                    regular_expression: false
                  name: rows
                  hidden: true
                  read_only: true
                  type: NUMBER
              - property:
                  value:
                    value: Hledat podle názvu podniku nebo města
                    regular_expression: false
                  name: placeholder
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: search
                    regular_expression: false
                  name: name
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: '524288'
                    regular_expression: false
                  name: max length
                  hidden: true
                  read_only: true
                  type: NUMBER
              - property:
                  value:
                    value: INPUT
                    regular_expression: false
                  name: html tag
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: SearchString
                    regular_expression: false
                  name: html id
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: default value
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ui-autocomplete-input
                    regular_expression: false
                  name: class
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: acc_name
                  hidden: true
                  read_only: true
                  type: STRING
              basic_identification:
                property_ref:
                - micclass
                - _xpath
                - type
                - name
                - html tag
                ordinal_identifier: ''
              smart_identification:
                base_filter:
                  property_ref:
                  - micclass
                  - type
                  - html tag
                optional_filter:
                  property_ref:
                  - name
                  - html id
                  - max length
                  - default value
                  - class
                  - rows
                  - placeholder
                  - acc_name
                algorithm: Mercury.TolerantPriority
                active: true
              custom_replay: ''
              comments: ''
              visual_relations: ''
              last_update_time: Thursday, June 25, 2020 9:37:36 AM
              child_objects: []
          - object:
              class: Link
              name: Hledat
              properties:
              - property:
                  value:
                    value: Link
                    regular_expression: false
                  name: micclass
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: //FORM[@id="search"]/A[1]
                    regular_expression: false
                  name: _xpath
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: '-1'
                    regular_expression: false
                  name: visible
                  hidden: true
                  read_only: true
                  type: BOOL
              - property:
                  value:
                    value: Hledat
                    regular_expression: false
                  name: text
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: '437'
                    regular_expression: false
                  name: source_index
                  hidden: true
                  read_only: true
                  type: NUMBER
              - property:
                  value:
                    value: Hledat
                    regular_expression: false
                  name: name
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: A
                    regular_expression: false
                  name: html tag
                  hidden: false
                  read_only: false
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: html id
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: javascript:document.search.submit();
                    regular_expression: false
                  name: href
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: class
                  hidden: true
                  read_only: true
                  type: STRING
              - property:
                  value:
                    value: ''
                    regular_expression: false
                  name: acc_name
                  hidden: true
                  read_only: true
                  type: STRING
              basic_identification:
                property_ref:
                - micclass
                - _xpath
                - text
                - html tag
                ordinal_identifier: ''
              smart_identification:
                base_filter:
                  property_ref:
                  - micclass
                  - html tag
                optional_filter:
                  property_ref:
                  - text
                  - html id
                  - class
                  - name
                  - href
                  - visible
                  - acc_name
                algorithm: Mercury.TolerantPriority
                active: true
              custom_replay: ''
              comments: ''
              visual_relations: ''
              last_update_time: Thursday, June 25, 2020 9:37:36 AM
              child_objects: []
  check_points_and_outputs:
  - check_point_and_output:
      standard_properties:
        standard_property:
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: testobjname
          flags: '3'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: testobjgentype
          flags: '3'
          inner_type: '0'
          type: STRING
        - value:
            value: Output Value
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: step_type
          flags: '88'
          inner_type: '8'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: parent
          flags: '9'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: objectid
          flags: '9'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: micclass
          flags: '3'
          inner_type: '0'
          type: STRING
        - value: ''
          visual_relations: ''
          parameter:
            value: menu
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
            type: Parameter
          name: innertext
          flags: '312'
          inner_type: '8'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: class name
          flags: '3'
          inner_type: '0'
          type: STRING
      settings: ''
      name: menu
      type: Output
      class: VerifyObj
  - check_point_and_output:
      standard_properties:
        standard_property:
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: testobjname
          flags: '3'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: testobjgentype
          flags: '3'
          inner_type: '0'
          type: STRING
        - value:
            value: Output Value
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: step_type
          flags: '88'
          inner_type: '8'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: parent
          flags: '9'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: objectid
          flags: '9'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: micclass
          flags: '3'
          inner_type: '0'
          type: STRING
        - value: ''
          visual_relations: ''
          parameter:
            value: food
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
            type: Parameter
          name: innertext
          flags: '312'
          inner_type: '8'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: class name
          flags: '3'
          inner_type: '0'
          type: STRING
      settings: ''
      name: food
      type: Output
      class: VerifyObj
  - check_point_and_output:
      standard_properties:
        standard_property:
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: testobjname
          flags: '3'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: testobjgentype
          flags: '3'
          inner_type: '0'
          type: STRING
        - value:
            value: Output Value
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: step_type
          flags: '88'
          inner_type: '8'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: parent
          flags: '9'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: objectid
          flags: '9'
          inner_type: '0'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: micclass
          flags: '3'
          inner_type: '0'
          type: STRING
        - value: ''
          visual_relations: ''
          parameter:
            value: day
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
            type: Parameter
          name: innertext
          flags: '312'
          inner_type: '8'
          type: STRING
        - value:
            value: ''
            regular_expression: false
            ignore_space: false
            match_case: false
            not_exact_match: false
            formula: false
          visual_relations: ''
          parameter: ''
          name: class name
          flags: '3'
          inner_type: '0'
          type: STRING
      settings: ''
      name: day
      type: Output
      class: VerifyObj
  parameters: []
