
# Don't ... ask ... questions !
export DEBIAN_FRONTEND='noninteractive'

if [ `id -u` = 0 ]; then
  sudo() {
    "$@"
  }
fi

fail() {
  echo "$@" >&2
  exit 1
}

has() {
  which $1 &>/dev/null
}

expand_path() {
  mkdir -p `dirname "$1"`
  cd `dirname "$1"`
  echo $PWD/`basename "$1"`
}
