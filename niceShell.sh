#!/bin/bash
#Variables
uva=$(pwd)
lofon="$HOME/.local/share/fonts"


#banner
echo """
      _                _          _ _ 
 _ __ (_) ___ ___   ___| |__   ___| | |
| '_ \| |/ __/ _ \ / __| '_ \ / _ \ | |
| | | | | (_|  __/ \__ \ | | |  __/ | |
|_| |_|_|\___\___| |___/_| |_|\___|_|_|

"""


function ctrl_c(){
  echo -e "\n\nEXIT.....\n"
  exit 1
}

#ctrl+c
trap ctrl_c INT
#update
function paquetes(){
  echo "[!]Actualizando paquetes"
  echo "[°]Privilegios sudo necesarios"
  sudo apt update >> ~/logs_install.txt 2>&1
  if [ $? != 0 ]; then
    cat << EOF

  [-]Fallo el update
  [-]Verificar /etc/apt/sources.list
  [-]Verificar conexion
EOF
    exit 1
  fi
  echo "[*]Instalando paquetes necesarios"
  sudo apt install -y curl git zsh python3 python3-pip zsh-autosuggestions zsh-syntax-highlighting wget ranger  >> ~/logs_install.txt 2>&1
  if [ $? != 0 ]; then
    cat << EOF
  [-]Fallo al momento de descargar los paquetes necesarios
  [-]Verificar conexion
EOF
    exit 1
  fi
  echo -e "\n[!!]SE RECOMIENDA CONFIGURAR LA ZSH, SI ES LA PRIMERA VEZ QUE LA USA"
  sleep 5
  clear
  echo -e "\n[°°]Si esta usando ubuntu se recomienda la opcion 2"
  sleep 5
  zsh
}

#install app
function niceApp(){
  echo "[*]Instalando programas"
  echo "[+]Cambiando la shell por defecto a zsh"
  #sudo chsh $USER -s $(which zsh) >> ~/logs_install.txt 2>&1
  #sudo chsh root -s $(which zsh) >> ~/logs_install.txt 2>&1
  sudo usermod --shell /usr/bin/zsh $USER
  sudo usermod --shell /usr/bin/zsh root
  #instalando nvim
  echo "[+]Descargando neovim"
  wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb -O nvim-linux64.deb >> ~/logs_install.txt 2>&1
  if [ -f "nvim-linux64.deb" ]; then
    echo "[+]Se descargo neovim correctamente"
  else
    echo "[-]Ocurrio un error al momento de descargar neovim"
    exit 1
  fi
  echo "[+]Instalando neovim en el equipo"
  sudo dpkg -i nvim-linux64.deb >> ~/logs_install.txt 2>&1
  if [ $? != 0 ]; then
    echo  "[-]Fallo al momento de instalar neovim"
    exit 1
  fi
  rm nvim-linux64.deb
  #Descargando Hack nerd fonts
  echo "[*]Descargando Hack Nerd Font "
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -O Hack.zip >> ~/logs_install.txt 2>&1
  if [ -f "Hack.zip" ]; then
    echo "[+]Se descargo Hack.zip correctamente"
  else
    echo "[-]Ocurrio un error al descargar las Hack Nerd Font"
    exit 1
  fi
  echo "[+]Instalando las fuente en el sistema"
  #mkdir $lofon
  #cp Hack.zip $lofon
  #cd $lofon
  #unzip Hack.zip >> ~/logs_install.txt 2>&1
  #rm Hack.zip
  #cd $uva
  sudo mv Hack.zip /usr/local/share/fonts/
  cd /usr/local/share/fonts/
  sudo unzip Hack.zip >> ~/logs_install.txt 2>&1
  sudo rm Hack.zip >> ~/logs_install.txt 2>&1
  cd $uva

  #Instalando batcat
  echo "[*]Descargando batcat"
  wget https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb -O bat_0.21.0_amd64.deb >> logs_install.txt 2>&1
  if [ -f "bat_0.21.0_amd64.deb" ]; then
    echo "[+]Se descargo batcat correctamente"
  else
    echo "[-]Ocurrio un error al descargar batcat"
    exit 1
  fi
  echo "[+]Instalando batcat en el sistema"
  sudo dpkg -i bat_0.21.0_amd64.deb >> logs_install.txt 2>&1
  echo "[+]Creando alias en .zshrc"
  echo "#Alias batcat " >> ~/.zshrc
  echo "alias cat='/usr/bin/bat'" >> ~/.zshrc
  echo "alias catn='/usr/bin/cat'" >> ~/.zshrc
  echo "alias catnl='/usr/bin/bat --paging=never'" >> ~/.zshrc
  rm bat_0.21.0_amd64.deb

  #Descargando lsd
  echo "[*]Descargando lsd"
  wget https://github.com/Peltoche/lsd/releases/download/0.22.0/lsd_0.22.0_amd64.deb >> ~/logs_install.txt 2>&1
  if [ -f "lsd_0.22.0_amd64.deb" ]; then
    echo "[+]Se descargo lsd correctamente"
  else
    echo "[-]Ocurrio un error al descargar lsd"
    exit 1
  fi
  echo "[+]Instalando lsd"
  sudo dpkg -i lsd_0.22.0_amd64.deb >> logs_install.txt 2>&1
  rm lsd_0.22.0_amd64.deb

  #Creando alias lsd
  echo "[+]Creando alias de lsd en .zshrc"
  echo "#Alias lsd" >> ~/.zshrc
  echo "alias ll='lsd -lh --group-dirs=first'" >> ~/.zshrc
  echo "alias la='lsd -a --group-dirs=first'" >> ~/.zshrc
  echo "alias l='lsd --group-dirs=first'" >> ~/.zshrc
  echo "alias lla='lsd -lha --group-dirs=first'" >> ~/.zshrc
  echo "alias ls='lsd --group-dirs=first'" >> ~/.zshrc

  #Descargando powerlevel10k
  echo "[*]Descargando powerlevel10k"
  cd $HOME
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k >> ~/logs_install.txt 2>&1
  echo "[+]Agregando al .zshrc"
  echo "#Agregando zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting" >> ~/.zshrc
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
  echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
  #echo "source /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" >> ~/.zshrc
  echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
  cd $uva

  #Descargando powerlelvel10k en root
  echo "[+]Descargando powerlevel10k en root"
  sudo cp ~/.zshrc /root/.zshrc
  sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k/ >> ~/logs_install.txt 2>&1
  echo "[+]Agregado al root"
  cd $uva

  #Descargando sudo-plugin
  echo "[*]Descargando sudo-plugin"
  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -O sudo.plugin.zsh >> ~/logs_install.txt 2>&1
  echo "[°]Requiere de privilegios"
  sudo mkdir /usr/share/zsh-plugins
  sudo chown $USER:$USER /usr/share/zsh-plugins
  mv sudo.plugin.zsh /usr/share/zsh-plugins/sudo.plugin.zsh >> ~/logs_install.txt 2>&1
  echo "[+]Agredando el plugin al .zshrc"
  echo 'source /usr/share/zsh-plugins/sudo.plugin.zsh' >> ~/.zshrc

  #Descargando fzf
  echo -e  "\n[*]Descargando fzf\n"
  echo -e "\n[!]IMPORTANTE REQUIERE INTERACCION CON DEL USUARIO"
  echo -e "\n[¡¡]CAMBIAR LA FUENTE POR DEFECTO EN LA TERMINA POR LAS HACK NERD FONTS"
  echo -e "\n[[*]]IMPORTANTE REINCICIAR DESPUES DE TERMINAR DE INSTALAR TODOAS LAS HERRAMIENTAS"
  echo ""
  sleep 5
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >> ~/logs_install.txt 2>&1
  ~/.fzf/install
  echo -e  "\n[*]Se recomienda cambiar la fuente de la terminal a las Hack nerd fonts y reiniciar el equipo"
}

#help panel
function helpPanel(){
  echo -e "\n[+] Uso:\n"
  echo -e "\td) Se recomienda esta opcion para descargar las dependecias necesarias"
  echo -e "\tp) Install zsh, batcat, powerlevel10k, fzf, sudo-plugin, lsd, zsh-shell-default"
  echo -e "\tk) Install kitty"
  echo -e "\th) Help Panel"
  exit 1
}

#counter
declare -i counter=0
while getopts "dpkh" arg; do
  case $arg in
    d) let counter+=1;;
    p) let counter+=2;;
    k) let counter+=3;;
    h) helpPanel;;
  esac
done

#condicionales
if [ $counter -eq 1 ]; then
  paquetes
elif [ $counter -eq 2 ];then
  niceApp
elif [ $counter -eq 3 ]; then
  kitIns
else
  helpPanel
fi
