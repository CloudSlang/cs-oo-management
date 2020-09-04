########################################################################################################################
#!!
#! @system_property central_url: RPA Central URL (https://hostname:8443/oo)
#! @system_property insights_url: RPA Insights service URL (https://hostname:8458/oo-insights)
#! @system_property designer_url: RPA Designer URL ((https://hostname:8445/oo-designer)
#! @system_property ssx_url: RPA SSX URL ((https://hostname:8446/oo-ssx)
#! @system_property idm_url: IDM URL ((https://hostname:8445/idm-service)
#! @system_property idm_username: IDM transport username
#! @system_property idm_password: IDM transport user password
#! @system_property idm_tenant: IDM Tenant
#! @system_property rpa_username: User to be authenticated by default
#! @system_property rpa_password: The user password
#! @system_property wait_time: Waiting time in seconds for long lasting operations (where status is being checked 
#!                             repeatedly)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa
properties:
  - central_url:
      value: 'https://rpa.mf-te.com:8443/oo'
      sensitive: false
  - insights_url:
      value: 'https://rpa.mf-te.com:8458/oo-insights'
      sensitive: false
  - designer_url:
      value: 'https://rpa.mf-te.com:8445/oo-designer'
      sensitive: false
  - ssx_url:
      value: 'https://rpa.mf-te.com:8446/oo-ssx'
      sensitive: false
  - idm_url:
      value: 'https://rpa.mf-te.com:8445/idm-service'
      sensitive: false
  - idm_username:
      value: idmTransportUser
      sensitive: false
  - idm_password:
      value: ''
      sensitive: true
  - idm_tenant:
      value: RPA
      sensitive: false
  - rpa_username:
      value: admin
      sensitive: false
  - rpa_password:
      value: ''
      sensitive: true
  - wait_time:
      value: '5'
      sensitive: false
