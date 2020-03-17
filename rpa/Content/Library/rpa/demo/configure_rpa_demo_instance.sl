########################################################################################################################
#!!
#! @description: Configures a freshly installed RPA demo instance. It
#!               - sets content pack settings
#!               - sets general settings
#!               - schedules flows to generate ROI in Dashboard
#!               - configures Insight service
#!               - enables Insight service
#!               - deletes password lock policy
#!               - creates SSX categories and scenarios
#!!#
########################################################################################################################
namespace: rpa.demo
flow:
  name: configure_rpa_demo_instance
  workflow:
    - set_general_settings:
        do:
          rpa.central.rest.settings.set_general_settings:
            - settings: isUseEmptyPromptForInputs
            - values: 'true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_cp_settings
    - generate_roi_numbers:
        do:
          rpa.demo.generate_roi_numbers: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_insight_settings
    - delete_password_lock_policy:
        do:
          rpa.demo.delete_password_lock_policy: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_sso_expiration_time
    - create_ssx_categories_and_scenarios:
        do:
          rpa.demo.create_ssx_categories_and_scenarios: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - set_cp_settings:
        do:
          rpa.central.rest.settings.set_cp_settings:
            - settings: 'cpStatisticsJobEnabled,cpExport'
            - values: 'true,true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: generate_roi_numbers
    - set_insight_settings:
        do:
          rpa.central.rest.insight.set_insight_settings:
            - settings: 'host,port,dbConfiguration.dbType,dbConfiguration.host,dbConfiguration.port,dbConfiguration.username,dbConfiguration.password,dbConfiguration.dbName,dbConfiguration.passwordChanged'
            - values: 'rpa.mf-te.com,8458,POSTGRESQL,rpa.mf-te.com,5432,insight,Cloud@123,insight,true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: enable_insight_service
    - enable_insight_service:
        do:
          rpa.central.rest.insight.enable_insight_service: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_password_lock_policy
    - set_sso_expiration_time:
        do:
          rpa.demo.set_sso_expiration_time: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_ssx_categories_and_scenarios
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_general_settings:
        x: 104
        'y': 65
      generate_roi_numbers:
        x: 402
        'y': 72
      delete_password_lock_policy:
        x: 103
        'y': 261
      create_ssx_categories_and_scenarios:
        x: 477
        'y': 258
        navigate:
          4047378a-1bc2-5248-824e-ab6deebdb8e3:
            targetId: 5bd93ad7-c706-1240-ecdc-927475693aa5
            port: SUCCESS
      set_cp_settings:
        x: 249
        'y': 71
      set_insight_settings:
        x: 585
        'y': 65
      enable_insight_service:
        x: 747
        'y': 70
      set_sso_expiration_time:
        x: 305
        'y': 260
    results:
      SUCCESS:
        5bd93ad7-c706-1240-ecdc-927475693aa5:
          x: 668
          'y': 265
