namespace: Integrations.aos
flow:
  name: authorize_db_ingress
  inputs:
    - instance_arn: 'arn:aws:rds:ap-southeast-1:775036367564:db:hybriddb04fd410'
    - cidrip: 172.16.239.10/32
    - port:
        default: '5432'
        private: true
    - protocol:
        default: tcp
        private: true
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time: []
        publish:
          - output
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: on_failure
    - describe_instances:
        do:
          io.cloudslang.amazon.aws.rds.instance.describe_instances:
            - region: "${instance_arn.split(':')[3]}"
            - instance_id: "${instance_arn.split(':')[6]}"
        publish:
          - instances_json
          - region
        navigate:
          - FAILURE: on_failure
          - SUCCESS: describe_vpcs
          - NOT_FOUND: FAILURE
    - authorize_sg_ingress:
        do:
          io.cloudslang.amazon.aws.ec2.security_group.authorize_sg_ingress:
            - region: '${region}'
            - sg_id: default
            - cidrip: '${cidrip}'
            - ip_protocol: tcp
            - from_port: '5432'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - describe_vpcs:
        do:
          io.cloudslang.amazon.aws.ec2.vpc.describe_vpcs:
            - region: '${region}'
            - default: 'true'
        publish:
          - vpc_ids
        navigate:
          - FAILURE: on_failure
          - SUCCESS: authorize_sg_ingress
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_instances:
        x: 95
        'y': 102
        navigate:
          cdce9375-9c92-c984-7d4a-f842ab1a0d7e:
            targetId: 47aa1ffc-1647-dd41-eff8-87c3eb108a3b
            port: NOT_FOUND
      authorize_sg_ingress:
        x: 506
        'y': 248
        navigate:
          9cdbd7c8-b8c3-5b6f-7bc9-94f3ecf77092:
            targetId: 3e1139d6-06e4-867e-8b0c-74925a31a8a8
            port: SUCCESS
      describe_vpcs:
        x: 300
        'y': 162.890625
      get_time:
        x: 238
        'y': 32.203125
    results:
      FAILURE:
        47aa1ffc-1647-dd41-eff8-87c3eb108a3b:
          x: 90
          'y': 316
      SUCCESS:
        3e1139d6-06e4-867e-8b0c-74925a31a8a8:
          x: 620
          'y': 72
