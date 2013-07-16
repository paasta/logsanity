
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

depend() {
  local depend_file="$1"
  local filter="$2"
  local deps=`cat "$depend_file" | grep " $filter" | sed -E -e "s/ +/ /g"`
  local apt_deps=`echo "$deps" | grep ' apt' | cut -d ' ' -f 1 | tr '\n' ' '`
  local gem_deps=`echo "$deps" | grep ' gem' | cut -d ' ' -f 1 | tr '\n' ' '`

  check_debs "$apt_deps"
  check_gems "$gem_deps"
}

check_debs() {
  local wanted="$@"
  [ -z "$wanted" ] && return

  local installed=`dpkg-query -l $wanted | grep -e '^ii ' | cut -d ' ' -f 3 2>/dev/null`
  local missing=`echo $wanted $installed | tr ' ' '\n' | sort | uniq -u | tr '\n' ' '`
  [ -z "$missing" ] && return

  echo "Missing DEBS: $missing"
  sudo apt-get update -qq
  sudo apt-get install -qy $missing
}

check_gems() {
  local wanted="$@"
  [ -z "$wanted" ] && return

  local installed=`gem list | cut -d ' ' -f 1 | tr '\n' ' '`
  local missing=`echo $wanted $installed | tr ' ' '\n' | sort | uniq -u | tr '\n' ' '`
  [ -z "$missing" ] && return

  echo "Missing GEMS: $missing"
  sudo gem install --no-ri --no-rdoc --force $missing
}
