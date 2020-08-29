########################################################################################################################
#!!
#! @description: Set the SSO expiration; provide the value in minutes; e.g. 1500 = 25 hours.
#!
#! @input timeout: For how long the SSO token should be valid (in minutes)
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.rpa.demo
flow:
  name: set_sso_expiration_time
  inputs:
    - timeout: '1500'
  workflow:
    - get_token:
        do:
          io.cloudslang.microfocus.rpa.idm.authenticate.get_token: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_sso_expiration_period
    - set_sso_expiration_period:
        do:
          io.cloudslang.microfocus.rpa.idm.configuration.set_property:
            - token: '${token}'
            - property_name: lwssoConfig.expirationPeriod
            - property_value: '${timeout}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_idm_token_lifetime
    - set_idm_token_lifetime:
        do:
          io.cloudslang.microfocus.rpa.idm.configuration.set_property:
            - token: '${token}'
            - property_name: idm.token.lifetime.minutes
            - property_value: '${timeout}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_sso_expiration_period:
        x: 189
        'y': 108
      set_idm_token_lifetime:
        x: 342
        'y': 110
        navigate:
          d8821c5d-4c02-16d4-71be-b0ee6f5b6f0d:
            targetId: a82959e3-8c41-7ca8-8278-efb41b398048
            port: SUCCESS
      get_token:
        x: 33
        'y': 110
    results:
      SUCCESS:
        a82959e3-8c41-7ca8-8278-efb41b398048:
          x: 508
          'y': 117
