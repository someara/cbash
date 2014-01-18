#set -e

# boolean checks
function is_mounted() {
    local mount_point="$1";
    local device="$2";
    mount | grep "^`printf '%q' "${mount_point}"`" | awk '{ print $3 }' | grep "`printf '%q' "${device}"`" 2>&1>/dev/null;
}

function is_lofi_associated(){
    local block_image="$1";
    lofiadm | grep `printf '%q' ${block_image}` | awk '{ print $2 }' | grep "^${block_image}$" 2>&1>/dev/null;
}

function has_windows_partitions(){
    local rblockdev="$1"
    [ -e ${rblockdev} ] &&
    [ `fdisk -W - ${rblockdev} | tail -n 4 | head -n 1 | awk '{ print $1 }'` == "12" ];
}

# helpers - definitions? return a string.
function get_lofi_association(){
    local block_image="$1";
    lofiadm | grep "`printf '%q' ${block_image}`" | awk '{ print $1 }';
}

function make_lofi_association(){
    local block_image="$1";
    if ! is_lofi_associated "${block_image}"; then
	lofiadm -a "${block_image}";
    fi
}

# attempters / "promises"
function mounted_block_image() {
  local block_image="$1";
  local block_image_mount="$2";
 
  if is_lofi_associated "${block_image}"; then
      local lofidev=`get_lofi_association ${block_image}`;
  else
      local lofidev=`make_lofi_association ${block_image}`;
  fi

  rlofidev=`echo ${lofidev} | sed -e 's/lofi/rlofi/'`

  if ! is_mounted ${block_image_mount} ${lofidev}; then

      if has_windows_partitions ${rlofidev}; then
	  /usr/bin/mkdir -p ${block_image_mount};
	  mount -F pcfs ${lofidev}:c ${block_image_mount};
      else
     	  mount ${lofidev} ${block_image_mount};
      fi

  fi
}

function unmounted_block_image(){
  local block_image="$1";
  local block_image_mount="$2";
  local lofidev=`get_lofi_association ${block_image}`;

  if is_mounted "${block_image_mount}" "${lofidev}"; then
      /usr/sbin/umount ${block_image_mount};
      /usr/sbin/lofiadm -d ${lofidev};
  fi
}

