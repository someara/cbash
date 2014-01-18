
function append_if_no_such_line() {
    local line="$1";
    local file="$2";
    if ! grep "^`printf '%q' "${line}"`$" ${file} 2>&1>/dev/null ; then
        echo "${line}" >> ${file}
    fi
}

function group() {
    local group="$1" ; local gid="$2"

    getent group | awk -F':' '{ print $1 }' | grep -q ^${group}$
    if [ $? -ne 0 ] ; then
        groupadd ${group}
    fi

    getent group | awk -F':' '{ print $3 }' | grep -q ^${gid}$
    if [ $? -ne 0 ] ; then 
        groupmod -g ${gid} ${group} 
    fi
}

function user() {
    local login="$1"; local uid="$2" ; local gid="$3"
    local comment="$4"; local homedir="$5"; local shell="$6"

    getent passwd ${login} | cut -d: -f 1 | grep -q ${login}
    if [ $? -ne 0 ]; then useradd ${login} -g ${gid} ; fi

    getent passwd ${login} | cut -d: -f 3 | grep -q ${uid}
    if [ $? -ne 0 ]; then usermod -u ${uid} ${login} ; fi

    getent passwd ${login} | cut -d: -f 4 | grep -q ${gid}
    if [ $? -ne 0 ]; then usermod -g ${gid} ${login} ; fi

    getent passwd ${login} | cut -d: -f 5 | grep -q "${comment}"
    if [ $? -ne 0 ]; then usermod -c "${comment}" ${login} ; fi

    getent passwd ${login} | cut -d: -f 6 | grep -q ${homedir}
    if [ $? -ne 0 ]; then usermod -m -d ${homedir} ${login} ; fi

    getent passwd ${login} | cut -d: -f 7 | grep -q ${shell} 
    if [ $? -ne 0 ]; then usermod -s ${shell} ${login} ; fi
}

function directory() {
    local path="$1"; local owner="$2";
    local group="$3"; local mode="$4";

    if [ ! -d ${path} ]; then
        mkdir -p ${path}
    fi

    if [ `stat -c '%U:%G' ${path}` != "${owner}:${group}" ]; then
        chown "${owner}:${group}" ${path}
    fi

    if [ `stat -c '%a' ${path}` != ${mode} ]; then
        chmod ${mode} ${path}
    fi
}

function absent_directory(){
    local path="$1";
    if [ -d ${path} ]; then
        rm -rf ${path};
    fi
}

function update_file() {
    local source="$1"; local dest="$2";
    cp -u ${source} ${dest}
}
