# Tailscale Buildkite Plugin

A Buildkite plugin to connect to your [Tailscale](https://tailscale.com/) network.

## Options

These are all the options available to configure this plugin's behaviour.

### Required

#### `client-id-env` (string)

The environment variable that the client ID is stored in.

#### `client-secret-env` (string)

The environment variable that the client secret is stored in.

#### `tags` (string)

The [device tags](https://tailscale.com/kb/1068/tags) this pipeline will use.

### Optional

#### `hostname` (string)

The hostname to use.

Defaults to `buildkite-${BUILDKITE_AGENT_NAME:-$(hostname)}`

#### `timeout` (number)

Connection timeout value in seconds.

Defaults to `120`. 

## Examples

Show how your plugin is to be used

```yaml
steps:
  - label: "🔨 Running plugin"
    command: "echo template plugin"
    plugins:
      - tailscale#v1.0.0:
          mandatory: "value"
```

## 📜 License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
