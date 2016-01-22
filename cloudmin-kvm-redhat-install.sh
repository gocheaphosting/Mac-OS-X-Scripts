#!/bin/sh
# cloudmin-kvm-redhat-install.sh
# Copyright 2005-2011 Virtualmin, Inc.
#
# Installs Cloudmin GPL for KVM and all dependencies on a CentOS, RHEL or
# Fedora system.

VER=1.1

# Define functions
yesno () {
	while read line; do
		case $line in
			y|Y|Yes|YES|yes|yES|yEs|YeS|yeS) return 0
			;;
			n|N|No|NO|no|nO) return 1
			;;
			*)
			printf "\nPlease enter y or n: "
			;;
		esac
	done
}

# Ask the user first
cat <<EOF
*******************************************************************************
*         Welcome to the Cloudmin GPL for KVM installer, version $VER         *
*******************************************************************************

 WARNING: This is an Early Adopter release.

 Operating systems supported by this installer are:

 Fedora Core 3-12 on i386 and x86_64
 CentOS and RHEL 3-5 on i386 and x86_64

 If your OS is not listed above, this script will fail (and attempting
 to run it on an unsupported OS is not recommended, or...supported).
EOF
printf " Continue? (y/n) "
if ! yesno
then exit
fi
echo ""

# Check for non-kernel mode flag
if [ "$1" = "--qemu" ]; then
	qemu=1
fi

# Cleanup old repo files
rm -f /etc/yum.repos.d/vm2* /etc/yum.repos.d/cloudmin*

# Check for KVM-capable CPU
echo Checking for hardware support for KVM ..
grep -e vmx -e svm /proc/cpuinfo >/dev/null
if [ $? != 0 ]; then
	echo .. not found. Make sure your CPU has Intel VT-x or AMD-V support
	echo ""
	exit 1
fi
echo .. found OK
echo ""

# Check for yum
echo Checking for yum ..
if [ ! -x /usr/bin/yum ]; then
	echo .. not installed. The Cloudmin installer requires YUM to download packages
	echo ""
	exit 1
fi
echo .. found OK
echo ""

# Make sure we have wget
echo "Installing wget .."
yum install -y wget
echo ".. done"
echo ""

# Check for wget or curl
echo "Checking for curl or wget..."
if [ -x "/usr/bin/curl" ]; then
	download="/usr/bin/curl -s "
elif [ -x "/usr/bin/wget" ]; then
	download="/usr/bin/wget -nv -O -"
else
	echo "No web download program available: Please install curl or wget"
	echo "and try again."
	exit 1
fi
echo "found $download"
echo ""

# Create Cloudmin licence file
echo Creating Cloudmin licence file
cat >/etc/server-manager-license <<EOF
SerialNumber=GPL
LicenseKey=GPL
EOF

# Download GPG keys
echo Downloading GPG keys for packages ..
$download "http://software.virtualmin.com/lib/RPM-GPG-KEY-virtualmin" >/etc/pki/rpm-gpg/RPM-GPG-KEY-virtualmin
if [ "$?" != 0 ]; then
	echo .. download failed
	exit 1
fi
$download "http://software.virtualmin.com/lib/RPM-GPG-KEY-webmin" >/etc/pki/rpm-gpg/RPM-GPG-KEY-webmin
if [ "$?" != 0 ]; then
	echo .. download failed
	exit 1
fi
echo .. done
echo ""

# Import keys
echo Importing GPG keys ..
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-virtualmin /etc/pki/rpm-gpg/RPM-GPG-KEY-webmin
echo .. done
echo ""

# Setup the YUM repo file
echo Creating YUM repository for Cloudmin packages ..
cat >/etc/yum.repos.d/cloudmin.repo <<EOF
[cloudmin-universal]
name=Cloudmin Distribution Neutral
baseurl=http://cloudmin.virtualmin.com/kvm/universal/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-virtualmin
gpgcheck=1
EOF
echo .. done
echo ""

# YUM install Perl, modules and other dependencies
echo Installing required Perl modules using YUM ..
yum install -y perl openssl perl-Net-SSLeay vixie-cron bind bind-utils kvm kvm-qemu-img qemu-kvm qemu-img qemu-kvm-tools kvm-tools kmod-kvm bridge-utils lsof parted
if [ "$?" != 0 ]; then
	echo .. install failed
	exit 1
fi
yum install -y perl-JSON
yum install -y dhcp
echo .. done
echo ""

# Activate KVM kernel module
if [ "$qemu" != 1 ]; then
	echo Activating KVM kernel module ..
	modprobe kvm-intel || modprobe kvm-amd
	/sbin/lsmod | grep kvm >/dev/null
	if [ "$?" != 0 ]; then
		echo .. kernel module did not load successfully
		exit 1
	fi
	if [ ! -e /dev/kvm ]; then
		echo .. KVM device file /dev/kvm is missing
		exit 1
	fi
	echo .. done
	echo ""
fi

# Create loop devices if missing
echo Creating /dev/loop devices ..
for loop in 0 1 2 3 4 5 6 7; do
	if [ ! -r "/dev/loop$loop" ]; then
		mknod "/dev/loop$loop" b 7 $loop
	fi
done
echo .. done
echo ""

# YUM install webmin, theme and Cloudmin
echo Installing Cloudmin packages using YUM ..
yum install -y webmin wbm-server-manager wbt-virtual-server-theme wbt-virtual-server-mobile wbm-security-updates
if [ "$?" != 0 ]; then
	echo .. install failed
	exit 1
fi
mkdir -p /kvm
echo .. done
echo ""

# Configure Webmin to use theme
echo Configuring Webmin ..
grep -v "^preroot=" /etc/webmin/miniserv.conf >/tmp/miniserv.conf.$$
echo preroot=virtual-server-theme >>/tmp/miniserv.conf.$$
cat /tmp/miniserv.conf.$$ >/etc/webmin/miniserv.conf
rm -f /tmp/miniserv.conf.$$
grep -v "^theme=" /etc/webmin/config >/tmp/config.$$
echo theme=virtual-server-theme >>/tmp/config.$$
cat /tmp/config.$$ >/etc/webmin/config
rm -f /tmp/config.$$
/etc/webmin/restart
echo .. done
echo ""

# Setup BIND zone for virtual systems
basezone=`hostname -d`
zone="cloudmin.$basezone"
echo Creating DNS zone $zone ..
/usr/libexec/webmin/server-manager/setup-bind-zone.pl --zone $zone --auto-view
echo kvm_zone=$zone >>/etc/webmin/server-manager/config
echo kvm_zone=$zone >>/etc/webmin/server-manager/this
if [ "$qemu" = 1 ]; then
	echo kvm_qemu=1 >>/etc/webmin/server-manager/config
fi
echo ""

# Enable bridge
echo Creating network bridge ..
/usr/libexec/webmin/server-manager/setup-kvm-bridge.pl
brex=$?
if [ "$brex" = 0 ]; then
	echo .. already active
else
	if [ "$brex" = 1 ]; then
		echo .. done
	else
		echo .. bridge creation failed
	fi
fi
echo ""

# Tell user about need to reboot
hostname=`hostname`
if [ "$brex" = 1 ]; then
	echo Cloudmin GPL has been successfully installed. However, you will
	echo need to reboot to activate the network bridge before any KVM
	echo instances can be created.
	echo
	echo One this is done, you can login to Cloudmin at :
	echo https://$hostname:10000/
else
	echo Cloudmin GPL has been successfully installed.
	echo
	echo You can login to Cloudmin at :
	echo https://$hostname:10000/
fi

# All done!
