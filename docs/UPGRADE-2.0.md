# Upgrade from v1.x to v2.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## Backwards incompatible changes

- Terraform AWS provider minimum supported version raised to `v5.0`
- Terraform minimum supported version raised to `v1.0`
- `broker_node_ebs_volume_size` has been removed since the `ebs_volume_size` argument was removed in `v5.0` of the AWS provider. Instead, storage settings should be configured using the `broker_node_storage_info` variable.
- `client_authentication_*` variables have been removed and replaced with `client_authentication` which supports the various authentication methods and configurations

## Additional changes

### Added

- None

### Modified

- Users can now utilize an externally created configuration by using the `create_configuration`, `configuration_arn`, and `configuration_revision` variables.

### Removed

- None

### Variable and output changes

1. Removed variables:

    - `broker_node_ebs_volume_size` -> replaced by `broker_node_storage_info`
    - `client_authentication_tls_certificate_authority_arns`-> replaced by `client_authentication`
    - `client_authentication_sasl_iam` -> replaced by `client_authentication`
    - `client_authentication_sasl_scram` -> replaced by `client_authentication`

2. Renamed variables:

    - None

3. Added variables:

    - `storage_mode`
    - `create_configuration`
    - `configuration_arn`
    - `configuration_revision`

4. Removed outputs:

    - None

5. Renamed outputs:

    - None

6. Added outputs:

    - None

## Upgrade Migrations

Note: Only the relevant changes are shown for brevity

### Before - v1.2 Example

```hcl
module "msk_kafka_cluster" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "1.2"

  broker_node_ebs_volume_size = 20

  client_authentication_sasl_scram = true

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster"
  }
}
```

### After - v2.0 Example

```hcl
module "msk_kafka_cluster" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "2.0"

  broker_node_storage_info = {
    ebs_storage_info = { volume_size = 20 }
  }

  client_authentication = {
    sasl = { scram = true }
  }

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster"
  }
}
```

### Diff of Before vs After

```diff
module "msk_kafka_cluster" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
-  version = "1.2"
+  version = "2.0"

-  broker_node_ebs_volume_size = 20
+  broker_node_storage_info = {
+    ebs_storage_info = { volume_size = 20 }
+  }

-  client_authentication_sasl_scram = true
+  client_authentication = {
+    sasl = { scram = true }
+  }

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/terraform-aws-modules/terraform-aws-msk-kafka-cluster"
  }
}
```

### State Move Commands

No Terraform state manipulation is required for this upgrade.
