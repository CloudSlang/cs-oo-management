########################################################################################################################
#!!
#! @description: Configures a freshly installed RPA demo instance. It
#!               - configures Insight service
#!               - enables Insight service
#!               - sets general settings
#!               - sets content pack settings
#!               - deletes password lock policy
#!               - extends SSO expiration timeout
#!               - creates (or updates) SSX categories and scenarios
#!               - schedules flows to generate ROI in Dashboard
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: configure_rpa_demo_instance
  workflow:
    - deploy_cps:
        do:
          io.cloudslang.microfocus.rpa.demo.deploy_cps: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_insight_settings
    - set_insight_settings:
        do:
          io.cloudslang.microfocus.rpa.central.insight.set_insight_settings:
            - settings: 'host,port,dbConfiguration.dbType,dbConfiguration.host,dbConfiguration.port,dbConfiguration.username,dbConfiguration.password,dbConfiguration.dbName,dbConfiguration.passwordChanged'
            - values: 'rpa.mf-te.com,8458,POSTGRESQL,rpa.mf-te.com,5432,insight,Cloud@123,insight,true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: enable_insight_service
    - set_general_settings:
        do:
          io.cloudslang.microfocus.rpa.central.settings.set_general_settings:
            - settings: isUseEmptyPromptForInputs
            - values: 'true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_cp_settings
    - generate_roi_numbers:
        do:
          io.cloudslang.microfocus.rpa.demo.generate_roi_numbers: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - delete_password_lock_policy:
        do:
          io.cloudslang.microfocus.rpa.demo.delete_password_lock_policy: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_sso_expiration_time
    - set_cp_settings:
        do:
          io.cloudslang.microfocus.rpa.central.settings.set_cp_settings:
            - settings: 'cpStatisticsJobEnabled,cpExport'
            - values: 'true,true'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_password_lock_policy
    - enable_insight_service:
        do:
          io.cloudslang.microfocus.rpa.central.insight.enable_insight_service: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_general_settings
    - set_sso_expiration_time:
        do:
          io.cloudslang.microfocus.rpa.demo.set_sso_expiration_time: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_ssx_categories_and_scenarios
    - update_ssx_categories_and_scenarios:
        do:
          io.cloudslang.microfocus.rpa.demo.update_ssx_categories_and_scenarios: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_demo_users
    - create_demo_users:
        do:
          io.cloudslang.microfocus.rpa.demo.create_demo_users: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: generate_roi_numbers
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_insight_settings:
        x: 172
        'y': 98
      generate_roi_numbers:
        x: 571
        'y': 395
        navigate:
          94c5ba29-62d2-5b1a-e0e9-5bcdf47814b0:
            targetId: 5bd93ad7-c706-1240-ecdc-927475693aa5
            port: SUCCESS
      deploy_cps:
        x: 31
        'y': 99
      create_demo_users:
        x: 291
        'y': 399
      set_sso_expiration_time:
        x: 301
        'y': 260
      enable_insight_service:
        x: 328
        'y': 100
      update_ssx_categories_and_scenarios:
        x: 458
        'y': 270
      delete_password_lock_policy:
        x: 96
        'y': 260
      set_general_settings:
        x: 531
        'y': 92
      set_cp_settings:
        x: 696
        'y': 97
    results:
      SUCCESS:
        5bd93ad7-c706-1240-ecdc-927475693aa5:
          x: 802
          'y': 269
