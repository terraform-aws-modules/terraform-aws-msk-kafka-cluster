# Upgrade from v2.x to v3.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## Backwards incompatible changes

- Terraform AWS provider minimum supported version raised to `v6.22.1`
- Terraform minimum supported version raised to `v1.5.7`

## Additional changes

### Added

- None

### Modified

- Variable definitions now contain detailed `object` types in place of the previously used any type

### Removed

- `connect_custom_plugin_timeouts`

### Variable and output changes

1. Removed variables:

    - None

2. Renamed variables:

    - None

3. Added variables:

    - None

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
