#!/bin/bash
clear
echo "Created by DanSavageGames. CA, USA"

# chmod stuff
sudo chmod 600 /boot/grub/grub.cfg
sudo chmod 600 /etc/security/opasswd
sudo chmod 640 /etc/shadow
sudo chmod 640 /etc/shadow-
sudo chmod 640 /etc/gshadow
sudo chmod 640 /etc/gshadow-
sudo chmod 644 /etc/passwd
sudo chmod 644 /etc/passwd-
sudo chmod 644 /etc/group
sudo chmod 644 /etc/group-
sudo chmod 644 /etc/shells
sudo chmod 777 ~/Desktop/backups
sudo chmod 777 ~/Desktop/backups/group
sudo chmod 777 ~/Desktop/backups/passwd

# CIS Benchmark

# 1.1.2.1.1
{
    systemctl unmask tmp.mount
}

# 1.2.2.1
{
    sudo apt update
    wait
    sudo apt upgrade
    wait
    sudo apt dist-upgrade
    wait
}

# 1.2.2.2
{
    mintupdate-automation upgrade enable
}

# 1.3.1.1
{
    apparmorIntalled = false; apparmorUtilsInstalled = false
    if [ $(dpkg-query -s apparmor &>/dev/null && echo "apparmor is installed" | grep "installed") ]; then
        apparmorInstalled = true
    fi
    if [ $(dpkg-query -s apparmor-utils &>/dev/null && echo "apparmor-utils is
installed" | grep "installed") ]; then
        apparmorUtilsInstalled = true
    fi
    
    if [ !apparmorInstalled ]; then
        sudo apt install apparmor
        wait
    fi
    if [ !apparmorUtilsInstalled ]; then
        sudo apt install apparmor-utils
        wait
    fi
}

# 1.3.1.2
{
    sed -i "GRUB_CMDLINE_LINUX=\"apparmor=1 security=apparmor\"" /etc/default/grub
    update-grub#
}

# Sysctl.conf
{
	sed -i '$a net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf 
	sed -i '$a net.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.conf
	sed -i '$a net.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.conf 

	sed -i '$a net.ipv4.conf.all.rp_filter=1' /etc/sysctl.conf

	sed -i '$a net.ipv4.conf.all.accept_source_route=0' /etc/sysctl.conf

	sed -i '$a net.ipv4.tcp_max_syn_backlog = 2048' /etc/sysctl.conf
	sed -i '$a net.ipv4.tcp_synack_retries = 2' /etc/sysctl.conf
	sed -i '$a net.ipv4.tcp_syn_retries = 5' /etc/sysctl.conf
	sed -i '$a net.ipv4.tcp_syncookies=1' /etc/sysctl.conf

	sed -i '$a net.ipv4.ip_foward=0' /etc/sysctl.conf
	sed -i '$a net.ipv4.conf.all.send_redirects=0' /etc/sysctl.conf
	sed -i '$a net.ipv4.conf.default.send_redirects=0' /etc/sysctl.conf
}

# Vsftpd.conf
{
    sed -i '$a anonymous_enable=NO' /etc/vsftpd.conf
    sed -i '$a local_enable=YES' /etc/vsftpd.conf

    sed -i '$a userlist_enable=YES' /etc/vsftpd.conf
    sed -i '$a userlist_file=/etc/vsftp.userlist' /etc/vsftpd.conf
    sed -i '$a userlist_deny=YES' /etc/vsftpd.conf

    sed -i '$a xferlog_enable=YES' /etc/vsftpd.conf
    sed -i '$a xfetlog_std_format=YES' /etc/vsftpd.conf
    sed -i '$a log_ftp_progocol=YES' /etc/vsftpd.conf
    sed -i '$a syslog_enable=YES' /etc/vsftpd.conf
    sed -i '$a xferlog_file=/var/log/vsftpd.conf' /etc/vsftpd.conf

    sed -i '$a ssl_enable=YES' /etc/vsftpd.conf
    sed -i '$a ssl_tlsv1=YES' etc/vsftpd.conf
    sed -i '$a ssl_tlsv2=NO' /etc/vsftpd.conf
    sed -i '$a ssl_tlsv3=NO' /etc/vsftpd.conf

    sed -i '$a user_sub_token=$USER' /etc/vsftpd.conf
    sed -i '$a local_root=/home/$USER/ftp' /etc/vsftpd.conf

    sed -i '$a chroot_local_user=YES' /etc/vsftpd.conf
    sed -i '$a chroot_list_enable=yes' /etc/vsftpd.conf
    sed -i '$a chroot_list_file=/etc/vsftpd.chroot_list' /etc/vsftpd.conf
    sed -i '$a allow_writeable_chroot=NO' /etc/vsftpd.conf
}

# Lightdm.conf
{
    touch /etc/lightdm/lightdm.conf
    sed -i 's/greeter-hide-users=.*/greeter-hide-users=true/' /etc/lightdm/lightdm.conf
    sed -i 's/greeter-allow-guest=.*/greeter-allow-guest=false/' /etc/lightdm/lightdm.conf
    sed -i 's/greeter-show-manual-login=.*/greeter-show-manual-login=true/' /etc/lightdm/lightdm.conf
    sed -i 's/allow-guest=.*/allow-guest=false/' /etc/lightdm/lightdm.conf
    sed -i 's/autologin-guest=.*/autologin-guest=false/' /etc/lightdm/lightdm.conf
    sed -i 's/autologin-user=.*/autologin-user=NONE/' /etc/lightdm/lightdm.conf

    sed -i 's/^# disable-user-.*/disable-user-list=true/' /etc/gdm3/greeter.dconf-defaults
    sed -i 's/^# disable-restart-.*/disable-restart-buttons=true/' /etc/gdm3/greeter.dconf-defaults
    sed -i 's/^#  AutomaticLoginEnable.*/AutomaticLoginEnable = false/' /etc/gdm3/custom.conf
    sed -i '$a allow-guest=false' /etc/lightdm/lightdm.conf
    sed -i '$a greeter-hide-users=true' /etc/lightdm/lightdm.conf
    sed -i '$a greeter-show-manual-login=true' /etc/lightdm/lightdm.conf
    
    sed -i 's/autologin-user=.*/autologin-user=none/' /etc/lightdm/lightdm.conf

    sed -i '$a [org/gnome/login-screen]' /etc/dconf/db/gdm.d/01-hide-users
    sed -i '$a banner-message-enable=true'/etc/dconf/db/gdm.d/01-hide-users
    sed -i '$a banner-message-text="This is a restricted server xd."' /etc/dconf/db/gdm.d/01-hide-users
    sed -i '$a disable-restart-buttons=true' /etc/dconf/db/gdm.d/01-hide-users
    sed -i '$a disable-user-list=true' /etc/dconf/db/gdm.d/01-hide-users
}

# Files
{
    echo "# Audio and Video" >> cypat.log
	sudo find / -name "*.abs" -type f -delete >> cypat.log
	sudo find / -name "*.aif*" -type f -delete >> cypat.log
	sudo find / -name "*.avi" -type f -delete >> cypat.log
	sudo find / -name "*.m4v" -type f -delete >> cypat.log
	sudo find / -name "*.mid*" -type f -delete >> cypat.log
	sudo find / -name "*.mod" -type f -delete >> cypat.log
	sudo find / -name "*.mov*" -type f -delete >> cypat.log
    sudo find / -name "*.mp4" -type f -delete >> cypat.log
    sudo find / -name "*.mp3" -type f -delete >> cypat.log
	sudo find / -name "*.mp2" -type f -delete >> cypat.log
	sudo find / -name "*.mpa" -type f -delete >> cypat.log
	sudo find / -name "*.mpeg*" -type f -delete >> cypat.log
	sudo find / -name "*.ogg" -type f -delete >> cypat.log
    sudo find / -name "*.wav" -type f -delete >> cypat.log

    echo "# Images" >> cypat.log
    sudo find / -name "*.gif" -type f -delete >> cypat.log
	sudo find / -name "*.ico" -type f -delete >> cypat.log
    sudo find / -name "*.im1" -type f -delete >> cypat.log
    sudo find / -name "*.jp*" -type f -delete >> cypat.log
    sudo find / -name "*.png" -type f -delete >> cypat.log
	sudo find / -name "*.svg*" -type f -delete >> cypat.log

    echo "# Others" >> cypat.log
    sudo find / -name "*.tar.gz" -type f -delete >> cypat.log
    sudo find / -name "*.php" -type f -delete >> cypat.log
    sudo find / -name "backdoor*.*" -type f -delete >> cypat.log
    sudo find / -nogroup >> cypat.log

    echo "\nMake sure to check cypat.log!"
    echo "Directory is listed below:"
    sudo find / -name "cypat.log"
}

# User authorized?
{
    for user in `cat users`; do
        read -p "$user is authorized? [y/n]: " a
        if [ $a = n ]; then
            sudo mv /home/$user /home/dis_$useradd
            sed -i -e "/$user/ s/^#*/#/" /etc/passwd
            sleep 1
        fi
    done
}

# User admin?
{
    for user in `cat users`; do
        read -p "$user is an admin? [y/n]: " a
        if [ $a = y ]; then
            sudo usermod -a -G sudo $useradd
        else 
            sudo deluser $user sudo
        fi
    done
}

# Add user?
{
    read -p "Is there a user to add? [y/n]: " a
    while [ $a = y ]; do
        read -p "Name: " username
        useradd $username
        mkdir /home/$username
        sudo passwd --expire $username
        read -p "Any more to add? [y/n]; " a
    done
}

# Hacking tools
{
    sudo apt autoremove john hydra samba hashcat nmap zenmap lighttpd netcat-traditional nikto ophcrack squid medusa maltego burp-suite spiderfoot qbittorrent deluge transmission-gtk transmission aircrack-ng netcat-openbsd ncat pnetcat socat sock socket sbd john-data hydra-gtk fcrackzip lcrack pdfcrack pyrit rarcrack sipcrack irpas zeitgeist-core zeitgeist-datahub python-zeitgeist rhythmbox-plugin-zeitgeist zeitgeist
    wait
    read -p "Keep nginx? [y/n]: " keepNginx
    read -p "Keep apache? [y/n]: " keepApache
    read -p "Keep wireshark? [y/n]: " keepWireshark
    {
        if [ $keepNginx = n ]; then
            sudo apt autoremove nginx
            wait
        fi
        if [ $keepApache = n ]; then
            sudo apt autoremove apache apache2
            wait
        else
            chown -R root:root /etc/apache2
            chown -R root:root /etc/apache
            echo \<Directory \> >> /etc/apache2/apache2.conf
            echo -e ' \t AllowOverride None' >> /etc/apache2/apache2.conf
            echo -e ' \t Order Deny,Allow' >> /etc/apache2/apache2.conf
            echo -e ' \t Deny from all' >> /etc/apache2/apache2.conf
            echo UserDir disabled root >> /etc/apache2/apache2.conf
            chmod 640 /etc/php5/apache2/php.ini
        fi
        if [ $keepWireshark = n ]; then
            sudo apt autoremove wireshark
            wait
        fi
    }
}

# ufw stuff
{
    sudo apt-get install ufw
    wait
    sudo ufw enable
    sudo ufw allow http
	sudo ufw allow https
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    read -p "Allow SSH? [y/n]: " a
    if [ $a = y ]; then
        ufw allow ssh
    else
        ufw deny ssh
    fi
}

END
