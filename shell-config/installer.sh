echo 'Adding Repos zsh & hstr'
#Alacritty
sudo add-apt-repository ppa:aslatter/ppa
echo 'Installing packages'
sudo apt-get update 
sudo apt install -y tmux hstr htop zsh git alacritty neovim

echo 'Installing TPM'
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo 'Downloading fonts'
if [ ! -d "~/.local/share/fonts" ] ; then
	mkdir ~/.local/share/fonts
fi
wget -O "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
wget -O "$HOME/.local/share/fonts/MesloLGS NF Bold.ttf" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
wget -O "$HOME/.local/share/fonts/MesloLGS NF Italic.ttf" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
wget -O "$HOME/.local/share/fonts/MesloLGS NF Bold Italic.ttf" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'
chmod 664 ~/.local/share/fonts/*
chmod 644 ~/.local/share/fonts/.uuid

#Refresh font cache
fc-cache -f -v

sid=$(ps -o sid= -p "$$")
sid_as_integer=$((sid)) # strips blanks if any
session_leader_parent=$(ps -o ppid= -p "$sid_as_integer")
session_leader_parent_as_integer=$((session_leader_parent))
emulator=$(ps -o comm= -p "$session_leader_parent_as_integer")
echo 'Copying .shellrc'
cp -r .shellrc ~/
echo 'Configuring Alacritty'
mkdir ~/.config/alacritty
ln -sf ~/.shellrc/alacritty.toml ~/.config/alacritty/alacritty.toml
echo 'Creating links to config files'
ln -sf ~/.shellrc/zshrc ~/.zshrc
ln -sf ~/.shellrc/.p10k.zsh ~/.p10k.zsh
ln -sf ~/.shellrc/.tmux.conf ~/.tmux.conf
#Reload tmux config to download plugins
tmux source ~/.tmux.conf
#default zsh a sshell
echo default zsh a sshell
chsh -s $(which zsh)

echo 'Installing docker'
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
TMPGID=$(id -gn) 
newgrp docker
newgrp $TMPGID
echo 'Installing docker compose'
sudo apt-get install docker-compose-plugin
echo 'Installing kubectl'
snap install kubectl --classic
