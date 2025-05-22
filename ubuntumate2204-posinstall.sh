#!/bin/sh

Script() {
    sudo echo -e "novasenha\nnovasenha" | sudo passwd secinfo
    sudo echo "10.0.0.1 intranet.om.eb.mil.br" >> /etc/hosts # Altere pro IP e domínio de sua Intranet
    sudo echo "10.0.0.2 sistemalocal.om.eb.mil.br" >> /etc/hosts # Adicione outros sistemas/servidores locais que não precisam do DNS do seu CT/CTA
    sudo apt install ntpdate -y
    sudo ntpdate ntp.cta.eb.mil.br # Altere pro NTP do seu CT/CTA
    sudo apt install ntp -y
    #Configuração ntp
    sudo cp ntp.conf /etc/ntp.conf

    ################################################################################
    #Desinstalar Softwares desnecessários
    sudo apt remove --purge cups-browsed -y 
    sudo apt remove --purge openssh-server -y
    sudo apt remove --purge transmission-common -y
    sudo apt remove --purge blueman -y 
    sudo apt remove --purge deja-dup -y 
    sudo apt remove --purge gufw -y 
    sudo apt remove --purge onboard -y 
    sudo apt remove --purge gucharmap -y 
    sudo apt remove --purge plank -y
    sudo apt remove --purge redshift-gtk -y 
    sudo apt remove --purge mate-tweak -y
    sudo apt remove --purge gnome-keyring -y
    sudo apt remove --purge magnus -y
    sudo apt remove --purge orca -y
    sudo apt remove --purge mate-optimus -y
    sudo apt remove --purge webcamoid -y
    sudo apt remove --purge celluloid -y
    sudo apt remove --purge rhythmbox -y
    sudo apt remove --purge libreoffice-core -y
    sudo snap remove firefox
    sudo apt autoremove firefox -y


    #Limpar cache
    sudo apt autoremove -y
    sudo apt autoclean -y

    ################################################################################
    sudo cp sources.list /etc/apt/sources.list
    sudo apt update
    sudo apt install cifs-utils -y
    sudo apt install firefox-locale-pt -y 
    sudo apt install wine-stable -y 
    sudo apt install samba -y 
    sudo apt install cups -y  
    sudo apt install rar -y 
    sudo apt install dconf-editor -y 
    sudo apt install dconf-cli -y 
    sudo apt install slick-greeter -y
    sudo add-apt-repository ppa:mozillateam/ppa
    sudo apt update
    sudo apt install firefox-esr -y
    sudo apt install firefox-esr-locale-pt -y

    sudo chown secinfo:secinfo -R .
    sudo chmod 775 -R .

    # USUÁRIO nomeom ################################################################
    sudo useradd -p $(openssl passwd nomeom) nomeom # Cria usuário nomeom (recomendável não criar usuários que iniciam com números)
    sudo usermod -c "Nome da OM" nomeom # Modifica o nome do usuário para que mostre no gerenciador de login de forma apresentável

    # Criação da pasta pessoal do usuário
    sudo mkhomedir_helper nomeom 
    sudo mkdir -p /home/nomeom/Área\ de\ Trabalho/
    sudo cp atalhos/* /home/nomeom/Área\ de\ Trabalho/
    sudo chown -R nomeom:nomeom /home/nomeom/
    sudo chmod 775 -R /home/nomeom/Área\ de\ Trabalho/
    sudo chmod -x /home/nomeom/Área\ de\ Trabalho/*.html
    ################################################################################

    # INICIO BLOQUEIOS #############################################################
    sudo cp logo.png /home/
    sudo cp lightdm/lightdm.conf /etc/lightdm/
    sudo cp lightdm/slick-greeter.conf /etc/lightdm/
    sudo cp lightdm/lightdm.conf.d/90-arctica-greeter.conf /etc/lightdm/lightdm.conf.d/
    sudo cp lightdm/lightdm.conf.d/91-arctica-greeter-guest-session.conf /etc/lightdm/lightdm.conf.d/
    sudo chown root:root -R /etc/lightdm
    sudo chmod 555 /home/logo.png
    sudo chmod 775 -R /etc/lightdm

    sudo rm -R /etc/dconf
    sudo mkdir -p /etc/dconf/profile
    sudo mkdir -p /etc/dconf/db/local.d/locks/

    sudo cp dconf/user /etc/dconf/profile/
    sudo cp dconf/lockall /etc/dconf/db/local.d/locks/
    sudo cp dconf/theme /etc/dconf/db/local.d/
    sudo cp dconf/panel /etc/dconf/db/local.d/
    
    gsettings set com.ubuntu.update-notifier show-apport-crashes false

    sudo dconf update
    killall dconf-service
    rm ~/.config/dconf/user
    marco --replace &
    ################################################################################

    # COPIAR rc.local
    sudo cp /home/auto/rc.local /etc/rc.local
    sudo chown root:root /etc/rc.local
    sudo chmod 751 /etc/rc.local

    # COPIAR crontab
    sudo cp /etc/crontab /etc/crontab.backup
    sudo cp /home/auto/crontab /etc/crontab
    sudo chown root:root /etc/crontab
    sudo chmod 644 /etc/crontab

    umount /home/auto/

    # INSTALAÇÃO .deb ##############################################################
    #sudo dpkg -i adobereader/adobereader.deb
    #sudo apt install -f -y

    #sudo apt remove --purge libreoffice7.0* -y
    #sudo dpkg -i libreoffice/LibreOffice7/DEBS/*.deb
    #sudo apt install -f -y
    #sudo dpkg -i libreoffice/LibreOffice7-language/DEBS/*.deb
    #sudo apt install -f -y

    #sudo dpkg -i chrome/google-chrome-stable_current_amd64.deb
    #sudo apt install -f -y
    ################################################################################

    # ANTIVIRUS ####################################################################
    sudo cp antivirus/smb.conf /etc/samba/smb.conf
    ################################################################################
    #INSTALAÇÃO E ATUALIZAÇÃO DO KASPERSKY
    #sudo sh kaspersky/att_kaspersky.sh 
    # FIM BLOQUEIOS ################################################################
    killall mate-panel caja
    ################################################################################

    sh /home/slave.sh
    sudo apt upgrade -y

    # Policies firefox-esr

    echo '{
        "policies": {
            "Homepage": {
                "URL": "http://intranet.nomeom.eb.mil.br",
                "Locked": false,
                "StartPage": "homepage"
            },
            "Bookmarks": [
                {
                    "URL": "http://intranet.nomeom.eb.mil.br",
                    "Title": "Intranet",
                    "Placement": "toolbar"
                },
                {
                    "URL": "http://sped.nomeom.eb.mil.br",
                    "Title": "Sped",
                    "Placement": "toolbar"
                }
            ]
        }
    '}' | sudo tee /etc/firefox/policies/policies.json'
}

ping www.google.com -c 1
        if [ $? -eq 0 ]
        then
            Script
        else
            echo "Parece que a rede não está logada, tente logar na rede e rodar o script novamente"
fi
