# Changelog

All notable changes to this project will be documented in this file.

## [2.12.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.11.1...v2.12.0) (2025-04-22)


### Features

* Add `bootstrap_brokers_public_*` to outputs ([#49](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/49)) ([1683690](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/168369031b85d02b8f59eae2fa0abefcc95b3078))

## [2.11.1](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.11.0...v2.11.1) (2025-03-07)


### Bug Fixes

* The logging info block should not be present if node types are "express*" ([#48](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/48)) ([846520e](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/846520ef07410e3a8012a004e0bd3912cc9d21f5))

## [2.11.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.10.0...v2.11.0) (2025-01-06)


### Features

* Add cluster name to outputs ([#45](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/45)) ([c2ac138](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/c2ac138dc8e98e5b05d66a85249917d5dc057225))

## [2.10.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.9.0...v2.10.0) (2024-11-26)


### Features

* Add tags to AppAutoscaling target ([#44](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/44)) ([f0857f3](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/f0857f3341ce4bb869ea11e7ad2a6d5a98d0149d))


### Bug Fixes

* Update CI workflow versions to latest ([#42](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/42)) ([d0682a9](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/d0682a9670b564f27697d5c0900147df1332a7b8))

## [2.9.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.8.1...v2.9.0) (2024-09-10)


### Features

* Create a new configuration when the Kafka version is changed to avoid `ConflictException: A resource with this name already exists` errors ([#40](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/40)) ([d5b4e6c](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/d5b4e6cac2f1f0619d15e6c4f4b26f764ff3ecd2))

## [2.8.1](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.8.0...v2.8.1) (2024-08-17)


### Bug Fixes

* Make `cloudwatch_log_group_class` type string ([#38](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/38)) ([92b7d8b](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/92b7d8bd09970374e2011e347e557865fd1fd34f))

## [2.8.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.7.0...v2.8.0) (2024-08-08)


### Features

* Add support for `cloudwatch_log_group_class` ([#36](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/36)) ([75244f0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/75244f0ab8a786942499bdb98759ed603d9122f9))

## [2.7.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.6.0...v2.7.0) (2024-08-05)


### Features

* Allow Glue Schema registry data format to be configurable ([#32](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/32)) ([3f4806e](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/3f4806ee70d49f74163028f38abb14bd4971dfce))

## [2.6.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.5.0...v2.6.0) (2024-05-14)


### Features

* MSK serverless cluster ([#28](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/28)) ([3635a3f](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/3635a3fa9d0fdaf72519e35aadbe1462c1dddf6e))

## [2.5.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.4.0...v2.5.0) (2024-03-18)


### Features

* Allow MSK configuration changes on running clusters ([#17](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/17)) ([4f31418](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/4f314184fda3cc60197be4054470aaaecccc7392))

## [2.4.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.3.1...v2.4.0) (2024-03-18)


### Features

* Suport MSK cluster policy resource and add `cluster_uuid` attribute ([#23](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/23)) ([e0c41cd](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/e0c41cd343c9216b7ca8d8542bdf04770b6a77af))

## [2.3.1](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.3.0...v2.3.1) (2024-03-06)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#22](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/22)) ([5311b62](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/5311b626e1d49bb5dc4a80bbc4e9c9ed11c38a62))

## [2.3.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.2.0...v2.3.0) (2023-09-14)


### Features

* Support disabling storage autoscaling ([#15](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/15)) ([174d261](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/174d26146749150920a96dce15e65dbd075cf88b))

## [2.2.0](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/compare/v2.1.0...v2.2.0) (2023-09-14)


### Features

* Add support for multi-vpc private connectivity ([#13](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/issues/13)) ([5612974](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster/commit/561297428f995d38b51d2a437b4834f9930c02d5))

## [2.1.0](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/compare/v2.0.0...v2.1.0) (2023-06-29)


### Features

* Repo has moved to [terraform-aws-modules](https://github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster) organization ([#9](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/issues/9)) ([386a310](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/commit/386a3103ede94c9341522fed85527459e3a1e5a2))


### Bug Fixes

* Make release workflow execute for last release w/ notice ([59e1c0f](https://github.com/clowdhaus/terraform-aws-msk-kafka-cluster/commit/59e1c0f5136dc0815b67f5584a83e98897f13ecb))
