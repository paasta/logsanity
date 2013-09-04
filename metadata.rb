name             "logsanity"
maintainer       "Jonas Pfenniger"
maintainer_email "jonas@mediacore.com"
license          "MIT"
description      "Logging for all !"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"

depends          "ark"
depends          "base"
depends          "elasticsearch"
depends          "java"
depends          "nginx"

supports 'ubuntu'
