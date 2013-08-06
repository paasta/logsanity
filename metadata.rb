name             "logsanity"
maintainer       "Jonas Pfenniger"
maintainer_email "jonas@mediacore.com"
license          "MIT"
description      "Logging for all !"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"

%w[
  ark
  base
  elasticsearch
  java
  nginx
].each { |cb| depends cb }

supports 'ubuntu'
