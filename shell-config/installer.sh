echo 'Adding Repos zsh & hstr'
#hstr
sudo add-apt-repository ppa:ultradvorka/ppa 
#Alacritty
sudo add-apt-repository ppa:mmstick76/alacritty 
echo 'Installing packages'
sudo apt-get update && sudo apt-get install -y hstr zsh git alacritty

echo 'Installing TPM'
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo 'Downloading fonts'
if [ ! -d "~/.local/share/fonts" ] ; then
	mkdir ~/.local/share/fonts
fi
wget -O '~/.local/share/fonts/MesloLGS NF Regular.ttf' 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
wget -O '~/.local/share/fonts/MesloLGS NF Bold.ttf' 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf'
wget -O '~/.local/share/fonts/MesloLGS NF Italic.ttf' 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf'
wget -O '~/.local/share/fonts/MesloLGS NF Bold Italic.ttf' 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf'
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
ln -sf ~/.shellrc/alacritty.yml ~/.config/alacritty/alacritty.yml
echo 'Creating links to config files'
ln -sf ~/.shellrc/zshrc ~/.zshrc
ln -sf ~/.shellrc/.p10k.zsh ~/.p10k.zsha
ln -sf ~/.shellrc/.tmux.conf ~/.tmux.conf
echo 'Installing docker'
sudo apt-get install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
echo 'Installing docker compose'
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
echo 'Installing kubectl'
snap install kubectl --classic
