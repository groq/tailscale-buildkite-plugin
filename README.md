# Tailscale Buildkite Plugin

A Buildkite plugin to connect to your [Tailscale](https://tailscale.com/) network.

## Options

These are all the options available to configure this plugin's behaviour.

### Required

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

```yaml
steps:
  - label: "🔨 Access my-service on the Tailnet"
    command: "curl http://my-service:8080"
    plugins:
    - groq/tailscale:
        # Export this value as part of the repo's hooks/pre-checkout
        client-secret-env: TAILSCALE_OAUTH_CLIENT_SECRET
        tags: tag:ci
```

## 📜 License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
