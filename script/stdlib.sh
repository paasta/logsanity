set -e

fail() {
  echo "$@" >&2
  exit 1
}

has() {
  which $1 &>/dev/null
}

install() {
  apt-get install -qy $@
}
