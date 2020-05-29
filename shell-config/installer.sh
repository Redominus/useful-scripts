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

