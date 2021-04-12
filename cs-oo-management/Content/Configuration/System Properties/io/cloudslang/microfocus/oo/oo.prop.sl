########################################################################################################################
#!!
#! @system_property central_url: OO/RPA Central URL (https://hostname:8443/oo)
#! @system_property insights_url: OO/RPA Insights service URL (https://hostname:8458/oo-insights)
#! @system_property designer_url: OO/RPA Designer URL ((https://hostname:8445/oo-designer)
#! @system_property ssx_url: OO/RPA SSX URL ((https://hostname:8446/oo-ssx)
#! @system_property idm_url: IDM URL ((https://hostname:8445/idm-service)
#! @system_property idm_username: IDM transport username
#! @system_property idm_password: IDM transport user password
#! @system_property idm_tenant: IDM Tenant
#! @system_property oo_username: User to be authenticated by default
#! @system_property oo_password: The user password
#! @system_property wait_time: Waiting time in seconds for long lasting operations (where status is being checked 
#!                             repeatedly)
#! @system_property proxy_host: Proxy host to access the OO/RPA instance
#! @system_property proxy_port: Proxy port to access the OO/RPA instance
#! @system_property proxy_username: Proxy user name to access the OO/RPA instance
#! @system_property proxy_password: Proxy user password to access the OO/RPA instance
#! @system_property tls_version: This input allows a list of comma separated values of the specific protocols to be
#!                               used.Valid: SSLv3, TLSv1, TLSv1.1, TLSv1.2. Default: 'TLSv1.2'
#! @system_property trust_all_roots: Specifies whether to enable weak security over SSL for all HTTP calls
#! @system_property x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the
#!                                           subject's
#!                                           Common Name (CN) or subjectAltName field of the X.509
#!                                           certificate.
#!                                           Valid: 'strict', 'browser_compatible', 'allow_all'
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.oo
properties:
  - central_url:
      value: 'https://hostname:8443/oo'
      sensitive: false
  - insights_url:
      value: 'https://hostname:8458/oo-insights'
      sensitive: false
  - designer_url:
      value: 'https://hostname:8445/oo-designer'
      sensitive: false
  - ssx_url:
      value: 'https://hostname:8446/oo-ssx'
      sensitive: false
  - idm_url:
      value: 'https://hostname:8445/idm-service'
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
  - oo_username:
      value: admin
      sensitive: false
  - oo_password:
      value: ''
      sensitive: true
  - wait_time:
      value: '5'
      sensitive: false
  - proxy_host:
      value: ''
      sensitive: false
  - proxy_port:
      value: '8080'
      sensitive: false
  - proxy_username:
      value: ''
      sensitive: false
  - proxy_password:
      value: ''
      sensitive: true
  - tls_version:
      value: TLSv1.2
      sensitive: false
  - trust_all_roots:
      value: 'false'
      sensitive: false
  - x_509_hostname_verifier:
      value: strict
      sensitive: false

