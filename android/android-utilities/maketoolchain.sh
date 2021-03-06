#!/bin/bash

: ${SDKVERSION:=23}
: ${OLDSDKVERSION:=17}
: ${STL:=libc++}
: ${GCCVERSION:=4.9}

usage() {
	cat <<END
$1 [options]
Options:
	--force		force overwrite of existing toolchains
	--sdkver	set sdk version, default ${SDKVERSION}
	--gccversion	set gcc version, default ${GCCVERSION}, no others exist
	--stl		set c++ stl to use: gnustl, libc++, stlport, default=$STL
	--help		this help
END
}

while : ; do
	case "$1" in
		--force)
			shift
			FORCE=--force
			;;
		--stl)
			shift
			STL=$1
			shift
			;;
		--sdkver)
			shift
			SDKVERSION=$1
			shift
			;;
		--oldsdkver)
			shift
			OLDSDKVERSION=$1
			shift
			;;
		--gccver)
			shift
			GCCVERSION=$1
			shift
			;;
		--help)
			usage "$0"
			exit 0
			;;
		-*)
			echo "Invalid option: $1"
			usage "$0"
			exit 1
			;;
		*)
			break
			;;
	esac
done

make_toolchain() {
	./build/tools/make-standalone-toolchain.sh \
		--platform=android-$2 \
		--verbose \
		--install-dir=`pwd`/my-android-toolchain$1 \
		--stl=$STL \
		--arch=arm$4 \
		--toolchain=$3 $FORCE
}

cd android-ndk

make_toolchain "" $SDKVERSION arm-linux-androideabi-$GCCVERSION ""
make_toolchain 64 $SDKVERSION aarch64-linux-android-$GCCVERSION 64
make_toolchain old $OLDSDKVERSION arm-linux-androideabi-$GCCVERSION ""

