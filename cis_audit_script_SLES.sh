#Author : fuh-se
#check to see if script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

##################################################
function audit_WithOutput () {

	if [[ $2 ]]; then
	    echo "$1,Complaince : Yes " >> $filename
	    echo -e "\n $:">>$filename
	else
	    echo "$1,Complaince : NO" >> $filename
	fi
}
function audit_WithNoOutput () {

	if [[ $2 ]]; then
		echo "$1,Complaince : NO" >> $filename
		echo -e "\n $2:">>$filename
	else
		echo "$1,Complaince : Yes" >> $filename
	fi
}
function audit_Exception () {
	echo "$1,exception" >> $filename
}

#####################################################
#get hostname
host=`hostname`
#get current date
dateTime=`date +"%m%d%y-%H%M"`
#create filename
filename="CIS_SLES-"$host"-"$dateTime".csv"
#create new file
touch $filename
#####################################################

#1 Install Updates, Patches and Additional Security Software 

#1.1 Disable Unused File System

echo "1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Scored)"
auditStep="1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Scored)"
auditCmd=`modprobe -n -v cramfs lsmod|grep -c cramfs`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.1.2 Ensure mounting of freevxfs filesystems is disabled (Scored)"
auditStep="1.1.1.2 Ensure mounting of freevxfs filesystems is disabled (Scored)"
auditCmd=`modprobe -n -v freevxfs lsmod | grep -c freevxfs`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.1.3 Ensure mounting of jffs2 filesystems is disabled (Scored)"
auditStep="1.1.1.3 Ensure mounting of jffs2 filesystems is disabled (Scored)"
auditCmd=`modprobe -n -v jffs2 lsmod | grep -c jffs2`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.1.4 Ensure mounting of hfs filesystems is disabled (Scored)"
auditStep="1.1.1.4 Ensure mounting of hfs filesystems is disabled (Scored)"
auditCmd=`modprobe -n -v hfs lsmod | grep -c hfs`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.1.5 Ensure mounting of hfsplus filesystems is disabled"
auditStep="1.1.1.5 Ensure mounting of hfsplus filesystems is disabled"
auditCmd=`modprobe -n -v hfsplus lsmod | grep -c hfsplus`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.2 Ensure seperate partition exists for /tmp (Scored)"
auditStep="1.1.2 Ensure seperate partition exists for /tmp (Scored)"
auditCmd=`mount | grep /tmp`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.1.3 Ensure nodev option is set on /tmp (Scored)"
auditStep="1.1.3 Ensure nodev option is set on /tmp (Scored)"
auditCmd=`mount | grep /tmp`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.4 Ensure nosuid option is set on /tmp (Scored)"
auditStep="1.1.3 Ensure nosuid option is set on /tmp (Scored)"
auditCmd=`mount | grep /tmp`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.5 Ensure noexec option is set on /tmp (Scored)"
auditStep="1.1.5 Ensure noexec option is set on /tmp (Scored)"
auditCmd=`mount | grep /tmp`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.6 Ensure seperate partition exists for /var (Scored)"
auditStep="1.1.6 Ensure seperate partition exists for /var (Scored)"
auditCmd=`mount | grep /var`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.7 Ensure seperate partition exists for /var/tmp (Scored)"
auditStep="1.1.7 Ensure seperate partition exists for /var/tmp (Scored)"
auditCmd=`mount | grep /var`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.8 Ensure nodev option is set on /var/tmp partition (Scored)"
auditStep="1.1.8 Ensure nodev option is set on /var/tmp partition (Scored)"
auditCmd=`mount|grep /var/tmp`
audit_WithNoOutput "$auditStep" "$auditCmd"
echo "1.1.9 Ensure nosuid option is set on /var/tmp (Scored)"

auditStep="1.1.9 Ensure nosuid option is set on /var/tmp (Scored)"
auditCmd=`mount|grep /var/tmp`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.1.10 Ensure noexec option is set on /var/tmp (Scored)"
auditStep="1.1.10 Ensure noexec option is set on /var/tmp (Scored)"
auditCmd=`mount|grep /var/tmp`
audit_WithNoOutput "$auditStep" "$auditCmd"

#1.1.11

echo "1.2.1 Ensure package manager repositories are configured (Not Scored)"
audit_Step="1.2.1 Ensure package manager repositories are configured (Not Scored)"
auditCmd=`zypper repos`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.2.2 Ensure GPG keys are configured (Not Scored)"
audit_Step="1.2.2 Ensure GPG keys are configured (Not Scored)"
auditCmd=`rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'`
audit_WithNoOutput "$auditStep" "$auditCmd"



echo -e "\e[1;31m ******1.3 Filesystem Integrity Checking******\e[0m"
audit_Step="*****1.3 Filesystem Integrity Checking*****"



echo "1.3.1 Ensure AIDE is installed (Scored)"
audit_Step="1.3.1 Ensure AIDE is installed (Scored)"
auditCmd=`rpm -q aide`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.3.2 Ensure Filesystem integrity is regularly checked (Scored)"
audit_Step="1.3.2 Ensure Filesystem integrity is regularly checked (Scored)"
auditCmd=`crontab -u root -l|grep aide`
audit_WithNoOutput "$auditStep" "$auditCmd"



echo -e "\e[1;31m ******1.4 Secure Boot Settings******\e[0m"
audit_Step="*****1.4 Secure Boot Settings*****"



echo "1.4.1 Enusre permissions on bootloader config are configured (Scored)"
audit_Step="1.4.1 Enusre permissions on bootloader config are configured (Scored)"
auditCmd=`stat /boot/grub2/grub.cfg`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.4.2 Ensure bootloader password is set (Scored)"
audit_Step="1.4.1 Enusre permissions on bootloader config are configured (Scored)"
auditCmd=`grep "^set superusers" /boot/grub2/grub.cfg grep "^password" /boot/grub2/grub.cfg`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.4.3 Ensure authentication required for single user mode (Not Scored)"
audit_Step="1.4.3 Ensure authentication required for single user mode (Not Scored)"
auditCmd=`grep /sbin/sulogin /usr/lib/systemd/system/rescue.service`
audit_WithNoOutput "$auditStep" "$auditCmd"



echo -e "\e[1;31m ******1.5 Additional Process Hardening******\e[0m"
audit_Step="******1.5 Additional Process Hardening******"
audit_Exception "$auditStep"


echo "1.5.1 Ensure core dumps are restricted (Scored)"
audit_Step="1.5.1 Ensure core dumps are restricted (Scored)"
auditCmd=`grep "hard core" /etc/security/limits.conf /etc/security/limits.d`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.5.2 Ensure XD/NX support is enabled (Not Scored)"
audit_Step="1.5.2 Ensure XD/NX support is enabled (Not Scored)"
auditCmd=`dmesg|grep NX`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.5.3 Ensure address space layout randomization is enabled (Scored)"
audit_Step="1.5.3 Ensure address space layout randomization is enabled (Scored)"
auditCmd=`sysctl kernel.randomize_va_space`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.5.4 Ensure prelink is disabled (Scored)"
audit_Step="1.5.4 Ensure prelink is disabled (Scored)"
auditCmd=`rpm -q prelink`
audit_WithNoOutput "$auditStep" "$auditCmd"




echo -e "\e[1;31m ******1.6 Mandatory Acess Control******\e[0m"
audit_Step="******1.5 Mandatory Acess Control******"





echo "1.6.1.1 Ensure SELinux is not disabled in bootloader configuration (Scored) "
audit_Step="1.6.1.1 Ensure SELinux is not disabled in bootloader configuration (Scored) "
audit_Cmd=`grep "^\s*linux" /boot/grub2/grub.cfg`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.6.1.2 Ensure the SELinux state is enforcing"
audit_Step="1.6.1.2 Ensure the SELinux state is enforcing"
audit_Cmd=`grep SELINUX=enforcing /etc/selinux/semanage.conf | sestatus`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.6.1.3 Ensure SELinux policy is configured"
audit_Step="1.6.1.3 Ensure SELinux policy is configured"
audit_Cmd=`SELINUXTYPE=targeted /etc/selinux/config | sestatus`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.6.1.4 Ensure SETroubleshoot is not installed (Scored)"
audit_Step="1.6.1.4 Ensure SETroubleshoot is not installed (Scored)"
audit_Cmd=`rpm -q settroubleshoot\e`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.6.1.5 Ensure the MCS Translation Service (mcstrans) is not installed (Scored)"
audit_Step="1.6.1.5 Ensure the MCS Translation Service (mcstrans) is not installed (Scored)"
audit_Cmd=`rpm -q mcstrans`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.6.1.6 Ensure no unconfined daemons exist (Scored)"
audit_Step="1.6.1.6 Ensure no unconfined daemons exist (Scored)"
audit_Cmd=`ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ':' ' ' | awk '{print $NF }'`
audit_WithNoOutput "$auditStep" "$auditCmd"




echo -e "\e[1;31m ******1.6.2 Configure AppArmor******\e[0m"
audit_Step="******1.6.2 Configure AppArmor******"




echo "1.6.2.1 Ensure AppArmor is not disabled in bootloader configuration (Scored)"
audit_Step="1.6.2.1 Ensure AppArmor is not disabled in bootloader configuration (Scored)"
audit_Cmd=`grep "^\s*linux" /boot/grub2/grub.cfg`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.6.2.2 Ensure all AppArmor Profiles are enforcing (Scored)"
audit_Step="1.6.2.2 Ensure all AppArmor Profiles are enforcing (Scored)"
audit_Cmd=`apparmor_status `
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.6.3 Ensure SELinux or AppArmor are installed (Not Scored)"
audit_Step="1.6.3 Ensure SELinux or AppArmor are installed (Not Scored)"
audit_Cmd=`rpm -q libselinux1 selinux-policy`
audit_WithNoOutput "$auditStep" "$auditCmd"



echo -e "\e[1;31m ******1.7 Warning Banners******\e[0m"
audit_Step="******1.7 Warning Banners******"



echo "1.7.1.1 Ensure message of the day is configured properly (Scored)"
audit_Step="1.7.1.1 Ensure message of the day is configured properly (Scored)"
audit_Cmd=`cat /etc/motd | egrep '(\\v|\\r\\m|\\s)' /etc/motd`
audit_WithNoOutput "$auditStep" "$auditCmd"

echo "1.7.1.2 Ensure local login warning banner is configured properly (Not Scored)"
audit_Step="1.7.1.2 Ensure local login warning banner is configured properly (Not Scored)"
audit_Cmd=`cat /etc/issue | egrep '(\\v|\\r|\\m|\\s)' /etc/issue`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.7.1.3 Ensure remote login warning banner is configured properly (Not Scored)"
audit_Step="1.7.1.3 Ensure remote login warning banner is configured properly (Not Scored)"
audit_Cmd=`cat /etc/issue.net|egrep '(\\v|\\r|\\m|\\s)' /etc/issue.net`
audit_WithNoOutput "$auditStep" "$auditCmd"


echo "1.7.1.4 Ensure permissions on /etc/motd are configured (Not Scored)"
audit_Step="1.7.1.4 Ensure permissions on /etc/motd are configured (Not Scored)"
audit_Cmd=`stat /etc/motd`
audit_WithNoOutput "$auditStep" "$auditCmd"




















