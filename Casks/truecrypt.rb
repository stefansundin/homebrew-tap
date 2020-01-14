cask 'truecrypt' do
  name 'TrueCrypt'
  app 'TrueCrypt.app'
  homepage 'https://github.com/stefansundin/truecrypt-mac'
  version '4'
  url "https://github.com/stefansundin/truecrypt-mac/releases/download/v#{version}/TrueCrypt.app.zip"
  sha256 'bed453039c9062930df2768550dc2c3f2cb2f60c449da15a59babdc2ac2e744e'
  depends_on cask: 'osxfuse'
end
