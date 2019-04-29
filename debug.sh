#! /bin/bash

#
# by TS, Apr 2019
#

# @param string $1 Path
# @param int $2 Recursion level
#
# @return string Absolute path
function realpath_osx() {
	local TMP_RP_OSX_RES=
	[[ $1 = /* ]] && TMP_RP_OSX_RES="$1" || TMP_RP_OSX_RES="$PWD/${1#./}"

	if [ -h "$TMP_RP_OSX_RES" ]; then
		TMP_RP_OSX_RES="$(readlink "$TMP_RP_OSX_RES")"
		# possible infinite loop...
		local TMP_RP_OSX_RECLEV=$2
		[ -z "$TMP_RP_OSX_RECLEV" ] && TMP_RP_OSX_RECLEV=0
		TMP_RP_OSX_RECLEV=$(( TMP_RP_OSX_RECLEV + 1 ))
		if [ $TMP_RP_OSX_RECLEV -gt 20 ]; then
			# too much recursion
			TMP_RP_OSX_RES="--error--"
		else
			TMP_RP_OSX_RES="$(realpath_osx "$TMP_RP_OSX_RES" $TMP_RP_OSX_RECLEV)"
		fi
	fi
	echo "$TMP_RP_OSX_RES"
}

# @param string $1 Path
#
# @return string Absolute path
function realpath_poly() {
	command -v realpath >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		realpath "$1"
	else
		realpath_osx "$1"
	fi
}

VAR_MYNAME="$(basename "$0")"
VAR_MYDIR="$(realpath_poly "$0")"
VAR_MYDIR="$(dirname "$VAR_MYDIR")"

# ----------------------------------------------------------

# Outputs CPU architecture string
#
# @return int EXITCODE
function _getCpuArch() {
	case "$(uname -m)" in
		x86_64*)
			echo -n "x86_64"
			;;
		aarch64)
			echo -n "arm_64"
			;;
		armv7*)
			echo -n "arm_32"
			;;
		*)
			echo "$VAR_MYNAME: Error: Unknown CPU architecture '$(uname -m)'" >/dev/stderr
			return 1
			;;
	esac
	return 0
}

_getCpuArch >/dev/null || exit 1

# ----------------------------------------------------------

cd "$VAR_MYDIR" || exit 1

LVAR_REPO_PREFIX="tsle"
LVAR_IMAGE_NAME="mdb-mkinstall-$(_getCpuArch)"
LVAR_IMAGE_VER="1.13"

# ----------------------------------------------------------

if [ ! -f config.sh ]; then
	echo "$VAR_MYNAME: Error: File config.sh not found. Aborting." >/dev/stderr
	echo "$VAR_MYNAME: You need to copy config-SAMPLE.sh to config.sh first." >/dev/stderr
	exit 1
fi

. config.sh || exit 1

# ----------------------------------------------------------

# @param string $1 Docker Image name
# @param string $2 optional: Docker Image version
#
# @returns int If Docker Image exists 0, otherwise 1
function _getDoesDockerImageExist() {
	local TMP_SEARCH="$1"
	[ -n "$2" ] && TMP_SEARCH="$TMP_SEARCH:$2"
	local TMP_AWK="$(echo -n "$1" | sed -e 's/\//\\\//g')"
	local TMP_IMGID="$(docker image ls "$TMP_SEARCH" | awk '/^'$TMP_AWK' / { print $3 }')"
	[ -n "$TMP_IMGID" ] && return 0 || return 1
}

LVAR_IMG_FULL="${LVAR_IMAGE_NAME}:${LVAR_IMAGE_VER}"

_getDoesDockerImageExist "${LVAR_REPO_PREFIX}/${LVAR_IMAGE_NAME}" "$LVAR_IMAGE_VER"
if [ $? -eq 0 ]; then
	LVAR_IMG_FULL="${LVAR_REPO_PREFIX}/$LVAR_IMG_FULL"
else
	_getDoesDockerImageExist "$LVAR_IMAGE_NAME" "$LVAR_IMAGE_VER"
	if [ $? -ne 0 ]; then
		echo "$VAR_MYNAME: Trying to pull image from repository '${LVAR_REPO_PREFIX}/'..."
		docker pull ${LVAR_REPO_PREFIX}/${LVAR_IMG_FULL}
		if [ $? -eq 0 ]; then
			LVAR_IMG_FULL="${LVAR_REPO_PREFIX}/$LVAR_IMG_FULL"
		else
			echo "$VAR_MYNAME: Error: could not pull image '${LVAR_REPO_PREFIX}/${LVAR_IMG_FULL}'. Aborting." >/dev/stderr
			exit 1
		fi
	fi
fi

# ----------------------------------------------------------

docker run \
	-e CF_MKINST_DOCK_NET_PREFIX="$CFG_MKINST_DOCK_NET_PREFIX" \
	-e CF_MKINST_DOCK_IMG_RELEASE_VERS="$LVAR_IMAGE_VER" \
	-e CF_MKINST_MOUNTPOINTS_BASE_ON_HOST="$VAR_MYDIR" \
	-e CF_MKINST_DEBUG_DONT_EXPORT_FINAL_IMG=$CFG_MKINST_DEBUG_DONT_EXPORT_FINAL_IMG \
	-e CF_MKINST_DEBUG_PWGENFNC=$CFG_MKINST_DEBUG_PWGENFNC \
	-e CF_MKINST_DEBUG_DISABLE_CLAMAV=$CFG_MKINST_DEBUG_DISABLE_CLAMAV \
	-e CF_MKINST_DEBUG_DISABLE_OPENDKIM=$CFG_MKINST_DEBUG_DISABLE_OPENDKIM \
	--rm \
	-it \
	-v "$VAR_MYDIR/build-output/":/root/build-output \
	-v "$VAR_MYDIR/build-temp/":/root/build-temp \
	-v /var/run/docker.sock:/var/run/docker.sock \
	--entrypoint /bin/bash \
	"$LVAR_IMG_FULL" \
	$@
