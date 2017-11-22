class SshTunnelProxy < Formula
  desc "Open SSH tunnels on-demand."
  homepage "https://github.com/stefansundin/ssh-tunnel-proxy"
  version "0.0.1"
  url "https://github.com/stefansundin/ssh-tunnel-proxy/archive/v#{version}.tar.gz"
  sha256 "f8e4e7fdaed48b78c154113f849c1a5e9c7492522717c58d8190001c75bff0c1"

  def install
    libexec.install "ssh-tunnel-proxy.rb", "Gemfile", "Gemfile.lock"
    (bin/"ssh-tunnel-proxy").write <<~EOF
      #!/bin/bash
      BUNDLE_GEMFILE=#{libexec}/Gemfile exec bundle exec ruby #{libexec}/ssh-tunnel-proxy.rb "$@"
    EOF
  end

  def caveats; <<~EOF
    To use this program you need Ruby installed.
    To install the gems required, please run:
    BUNDLE_GEMFILE=#{libexec}/Gemfile bundle install

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
end
