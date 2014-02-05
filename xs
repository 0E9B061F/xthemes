#!/bin/bash
#
# USAGE: xs style
#        xs list [QUERY]
#        xs set NAME
#        xs blank
#  DESC: Manage X styles. The currently-selected style will be linked to by
#        '~/.current.xstyle'. To use the selected style, your '.Xresources'
#        or '.Xdefaults' file must contain a line like 
#        '#include "/home/USER/.current.style"'. Any affected X programs
#        must be restarted before style changes will become apparent.
#        The default command is 'style'
#    BY: Macquarie <macquarie.sharpless@gmail.com> 2014
#        grimheart.github.com

XS_STYLEDIR=${HOME}/.Xstyles
XS_BLANKSTYLE=${XS_STYLEDIR}/blank.xstyle
XS_CURRENTSTYLE=${HOME}/.current.xstyle
XS_CURRENTNAME=$(readlink ${XS_CURRENTSTYLE})



xs.strip() {
  local filename="${1}"
  basename "${filename}" .xstyle
}



xs.cmd.style() {
  [ -n "${XS_CURRENTNAME}" ] && xs.strip "${XS_CURRENTNAME}"
}

xs.cmd.list() {
  local query=${1}
  ls ${XS_STYLEDIR} | grep "^${query}" | sed 's/\.xstyle$//'
}

xs.cmd.set() {
  local name=${1}
  local style=$(ls ${XS_STYLEDIR} | grep -m1 "^${name}")
  if [ -n "${style}" ]; then
    rm -f "${XS_CURRENTSTYLE}" &> /dev/null
    ln -s "${XS_STYLEDIR}/${style}" "${XS_CURRENTSTYLE}"
  fi
  echo "Changed style to '$(xs.strip "${style}")'"
}

xs.cmd.blank() {
  xs.cmd.set "blank.xstyle"
}



xs.main() {
  local cmd=${1}
  local args=${@:2}
  [ -z "${cmd}" ] && cmd="style"
  xs.cmd.${cmd} ${args}
}

xs.main ${@}

