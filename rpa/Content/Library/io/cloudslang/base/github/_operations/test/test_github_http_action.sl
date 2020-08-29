namespace: io.cloudslang.base.github._operations.test
flow:
  name: test_github_http_action
  workflow:
    - github_http_action:
        parallel_loop:
          for: "url in '/repos/pe-pan/rpa-aos,/repos/pe-pan/rpa-aos/releases,/repos/pe-pan/rpa-salesforce,/repos/pe-pan/rpa-salesforce/releases,/repos/rpa-micro-focus/rpa-rpa,/repos/rpa-micro-focus/rpa-rpa/releases,/repos/pe-pan/rpa-sap,/repos/pe-pan/rpa-sap/releases'"
          do:
            io.cloudslang.base.github._operations.github_http_action:
              - url: '${url}'
              - method: GET
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      github_http_action:
        x: 125
        'y': 146
        navigate:
          2c9c9de2-325f-48c0-e286-34e71a8a1eb9:
            targetId: 83473298-4ad9-020e-f64f-c522030c9c2c
            port: SUCCESS
    results:
      SUCCESS:
        83473298-4ad9-020e-f64f-c522030c9c2c:
          x: 297
          'y': 137
