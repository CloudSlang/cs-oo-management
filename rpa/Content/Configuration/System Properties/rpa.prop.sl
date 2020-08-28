namespace: ''
properties:
  - central_url: 'https://rpa.mf-te.com:8443/oo'
  - insights_url: 'https://rpa.mf-te.com:8458/oo-insights'
  - designer_url: 'https://rpa.mf-te.com:8445/oo-designer'
  - ssx_url: 'https://rpa.mf-te.com:8446/oo-ssx'
  - idm_url: 'https://rpa.mf-te.com:8445/idm-service'
  - idm_username: idmTransportUser
  - idm_password:
      value: Cloud@123
      sensitive: true
  - idm_tenant: RPA
  - rpa_username: admin
  - rpa_password:
      value: Cloud@123
      sensitive: true
  - wait_time:
      value: '5'
      sensitive: false
  