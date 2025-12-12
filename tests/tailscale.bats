#!/usr/bin/env bats

load "${BATS_PLUGIN_PATH}/load.bash"

# export NOHUP_STUB_DEBUG=/dev/tty
# export TAILSCALE_STUB_DEBUG=/dev/tty
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

setup() {
  export TAILSCALE_CLIENT_SECRET=client-secret
}

@test "client secret connection" {
  export BUILDKITE_PLUGIN_TAILSCALE_CLIENT_SECRET_ENV=TAILSCALE_CLIENT_SECRET
  export BUILDKITE_PLUGIN_TAILSCALE_TAGS=tags:ci

  stub nohup \
    "tailscaled --state=mem: : exit 0"

  stub tailscale \
    "status --json : exit 0" \
    "up --authkey=client-secret?preauthorized=true\\&ephemeral=true --hostname=buildkite-$(hostname) --advertise-tags=tags:ci --accept-routes --timeout 120s : exit 0" \
    "status : exit 0"

  run bash -c "$PWD/hooks/pre-command"

  assert_success
  assert_output --partial '~~~ Waiting for Tailscale daemon to start...'
  assert_output --partial '🌐 Connecting to Tailscale network...'
  assert_output --partial '✅ Tailscale daemon started successfully'
  assert_output --partial '✅ Successfully connected to Tailscale!'

  unstub nohup
  unstub tailscale
}

@test "client ID connection" {
  export BUILDKITE_PLUGIN_TAILSCALE_CLIENT_ID="client-id"
  export BUILDKITE_PLUGIN_TAILSCALE_TAGS=tags:ci

  stub nohup \
    "tailscaled --state=mem: : exit 0"

  stub buildkite-agent \
    "oidc request-token --audience tailscale.com : echo id-token"

  stub tailscale \
    "status --json : exit 0" \
    "up --client-id=client-id?preauthorized=true\\&ephemeral=true --id-token=id-token --hostname=buildkite-$(hostname) --advertise-tags=tags:ci --accept-routes --timeout 120s : exit 0" \
    "status : exit 0"

  run bash -c "$PWD/hooks/pre-command"

  assert_success
  assert_output --partial '~~~ Waiting for Tailscale daemon to start...'
  assert_output --partial '🌐 Connecting to Tailscale network...'
  assert_output --partial '✅ Tailscale daemon started successfully'
  assert_output --partial '✅ Successfully connected to Tailscale!'

  unstub nohup
  unstub buildkite-agent
  unstub tailscale
}
