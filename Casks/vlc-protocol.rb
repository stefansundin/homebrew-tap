cask 'vlc-protocol' do
  name 'VLC-protocol'
  app 'VLC-protocol.app'
  homepage 'https://github.com/stefansundin/vlc-protocol'
  version '1.1.0'
  url "https://github.com/stefansundin/vlc-protocol/releases/download/v#{version}/VLC-protocol.app.zip"
  sha256 'a05e07e100cb322315a724bb6f77139a79d78ae52d03036663d9a7d9d67f71dc'
end
