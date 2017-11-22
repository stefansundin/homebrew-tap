class SshTunnelProxy < Formula
  desc "Open SSH tunnels on-demand."
  homepage "https://github.com/stefansundin/ssh-tunnel-proxy"
  version "0.0.1"
  url "https://github.com/stefansundin/ssh-tunnel-proxy/archive/v#{version}.tar.gz"
  sha256 "f8e4e7fdaed48b78c154113f849c1a5e9c7492522717c58d8190001c75bff0c1"
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
    - It assumes you are using rbenv. If you are not, you have to edit the plist.
    - Logs are saved to: #{var}/log/ssh-tunnel-proxy/

    Config is loaded from ~/.ssh-tunnel-proxy.toml
    Example config:

    [[tunnel]]
    local_interface = "localhost" # This tunnel only accepts connections from your own computer
    local_port = 8881
    remote_host = "localhost"
    remote_port = 8880
    user = "my_username"
    host = "dev1.example.com"
    proxy_jump = "my_username@bastion.example.com"
    EOF
  end

  def plist; <<~EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/ssh-tunnel-proxy</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardOutPath</key>
      <string>#{var}/log/ssh-tunnel-proxy/stdout.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/ssh-tunnel-proxy/stderr.log</string>
    </dict>
    </plist>
    EOF
  end
end
