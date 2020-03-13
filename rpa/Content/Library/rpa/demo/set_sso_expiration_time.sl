########################################################################################################################
#!!
#! @description: Set the SSO expiration; provide the value in minutes; e.g. 1500 = 25 hours.
#!
#! @input timeout: For how long the SSO token should be valid (in minutes)
#!!#
########################################################################################################################
namespace: rpa.demo
flow:
  name: set_sso_expiration_time
  inputs:
    - timeout: '1500'
  workflow:
    - set_sso_expiration_period:
        do:
          rpa.idm.rest.configuration.set_property:
            - property_name: lwssoConfig.expirationPeriod
            - property_value: '${timeout}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_idm_token_lifetime
    - set_idm_token_lifetime:
        do:
          rpa.idm.rest.configuration.set_property:
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
        x: 76
        'y': 110
      set_idm_token_lifetime:
        x: 234
        'y': 112
        navigate:
          d8821c5d-4c02-16d4-71be-b0ee6f5b6f0d:
            targetId: a82959e3-8c41-7ca8-8278-efb41b398048
            port: SUCCESS
    results:
      SUCCESS:
        a82959e3-8c41-7ca8-8278-efb41b398048:
          x: 381
          'y': 111
