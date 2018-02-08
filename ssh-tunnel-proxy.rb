class SshTunnelProxy < Formula
  desc "Open SSH tunnels on-demand."
  homepage "https://github.com/stefansundin/ssh-tunnel-proxy"
  version "0.0.3"
  url "https://github.com/stefansundin/ssh-tunnel-proxy/archive/v#{version}.tar.gz"
  sha256 "a120250e7a297d4a1c99e574a23356b56ebe5b58a214cba65e44a4134268976a"
  plist_options manual: "ssh-tunnel-proxy"

  def install
    libexec.install "ssh-tunnel-proxy.rb", "Gemfile", "Gemfile.lock"
    (bin/"ssh-tunnel-proxy").write <<~EOF
      #!/bin/bash
      PATH="$HOME/.rbenv/shims:$PATH"
      BUNDLE_GEMFILE=#{libexec}/Gemfile exec bundle exec ruby #{libexec}/ssh-tunnel-proxy.rb "$@"
    EOF
  end

  def post_install
    (var/"log/ssh-tunnel-proxy").mkpath
  end

  def caveats; <<~EOF
    To use this program you need Ruby installed.
    To install the gems required, please run:
    BUNDLE_GEMFILE=#{libexec}/Gemfile bundle install

    Notes for using the service:
    - It assumes you are using rbenv. If you are not, you have to edit #{bin}/ssh-tunnel-proxy
    - Logs are saved to: #{var}/log/ssh-tunnel-proxy/

    Config is loaded from ~/.ssh-tunnel-proxy.toml
    Example config:

    timeout = 300 # Time (in seconds) to keep tunnels with no connections open before closing them
    [[tunnel]]
    user = "my_username"
    host = "dev1.example.com"
    proxy_jump = "my_username@bastion.example.com"
    [[tunnel.forward]]
    local_interface = "localhost" # This tunnel only accepts connections from your own computer
    local_port = 8881
    remote_host = "localhost"
    remote_port = 8880

    For all the configuration options available, see:
    https://github.com/stefansundin/ssh-tunnel-proxy/blob/master/ssh-tunnel-proxy.toml
    EOF
  end

  def plist; <<~EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>Program</key>
      <string>#{opt_bin}/ssh-tunnel-proxy</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>/usr/local/etc</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/ssh-tunnel-proxy/stdout.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/ssh-tunnel-proxy/stderr.log</string>
    </dict>
    </plist>
    EOF
  end
end
