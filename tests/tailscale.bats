#!/usr/bin/env bats

load "${BATS_PLUGIN_PATH}/load.bash"

# export SUDO_STUB_DEBUG=/dev/tty

setup() {
  export TAILSCALE_CLIENT_ID=client-id
  export TAILSCALE_CLIENT_SECRET=client-secret
}

@test "connection" {
  export BUILDKITE_PLUGIN_TAILSCALE_CLIENT_SECRET_ENV=TAILSCALE_CLIENT_SECRET
  export BUILDKITE_PLUGIN_TAILSCALE_TAGS=tags:ci

  stub sudo \
    "-b /bin/bash -c 'nohup tailscaled --state=mem: > /var/log/tailscaled.log &' : exit 0" \
    "tailscale status --json : exit 0" \
    "tailscale up --authkey=client-secret?preauthorized=true\\&ephemeral=true --hostname=buildkite-$(hostname) --advertise-tags=tags:ci --accept-routes --timeout 120s : exit 0" \
    "tailscale status : exit 0"

  run bash -c "$PWD/hooks/pre-command"

  assert_success
  assert_output --partial '~~~ Waiting for Tailscale daemon to start...'
  assert_output --partial '🌐 Connecting to Tailscale network...'
  assert_output --partial '✅ Tailscale daemon started successfully'
  assert_output --partial '✅ Successfully connected to Tailscale!'

  unstub sudo
}
