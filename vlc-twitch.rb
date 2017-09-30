class VlcTwitch < Formula
  desc "Twitch.tv playlist parser for VLC."
  homepage "https://addons.videolan.org/p/1167220/"
  head "https://gist.github.com/c200324149bb00001fef5a252a120fc2.git"

  def install
    (share+"vlc-twitch").install "twitch.lua"
    (share+"vlc-twitch").install "twitch-extension.lua"
  end

  def post_install
    ln_sf share/"vlc-twitch/twitch.lua", "#{ENV["HOME"]}/Library/Application Support/org.videolan.vlc/lua/playlist/twitch.lua"
    ln_sf share/"vlc-twitch/twitch-extension.lua", "#{ENV["HOME"]}/Library/Application Support/org.videolan.vlc/lua/extensions/twitch-extension.lua"
  end

  def caveats
    <<-EOS.unindent
      This formula needs to create symlinks at the following locations:
      '#{ENV["HOME"]}/Library/Application Support/org.videolan.vlc/lua/playlist/twitch.lua'
      '#{ENV["HOME"]}/Library/Application Support/org.videolan.vlc/lua/extensions/twitch-extension.lua'

      But because of Homebrew's sandbox mode, it doesn't have permissions to do so.
      If you get an error about the post-install above, then please run this command:

      brew postinstall --no-sandbox stefansundin/tap/vlc-twitch

      To avoid this when installing, use this command:

      brew install --no-sandbox --HEAD stefansundin/tap/vlc-twitch

      When you uninstall vlc-twitch, these symlinks are not automatically removed. It is ok to leave them, however.
    EOS
  end
end
