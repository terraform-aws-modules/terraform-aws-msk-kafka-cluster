# Upgrade from v2.x to v3.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## Backwards incompatible changes

- Terraform AWS provider minimum supported version raised to `v6.22.1`
- Terraform minimum supported version raised to `v1.5.7`
- `connect_custom_plugin_timeouts` removed in favor of `connect_custom_plugins.timeouts`

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

### Before - v2 Example

```hcl
module "msk_kafka_cluster" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "2.0"

  # Only the affected attributes are shown
  connect_custom_plugin_timeouts = {
    create = "20m"
  }
}
```

### After - v3.0 Example

```hcl
module "msk_kafka_cluster" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "3.0"

  # Only the affected attributes are shown
  connect_custom_plugins = {
    debezium = {
      timeouts = {
        create = "20m"
      }
    }
  }
}
```

### State Move Commands

No Terraform state manipulation is required for this upgrade.
