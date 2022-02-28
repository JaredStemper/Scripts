#zsh doesn't treat # as a comment start on the command line by default, only in scripts (including .zshrc and such)
setopt interactive_comments
#allow certain wildcard patterns (e.g. (foo|bar) and more)
setopt extended_glob
#change directory by name without cd
setopt auto_cd

####consider moving over to testing autorecon2 at some point

touch ~/.hushlogin

wget https://raw.githubusercontent.com/JaredStemper/Scripts/main/bash_aliases https://raw.githubusercontent.com/JaredStemper/Scripts/main/vimrc https://raw.githubusercontent.com/JaredStemper/Scripts/main/tmux.conf

sudo apt update && sudo apt install -y dconf-editor dconf-cli tldr tree sl docker trash-cli xclip python3 python3-pip python3-venv

#vim
##remove autocomplete (requires advanced setup)
##install plugins through Vundle
mv vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

#tmux
#clone repo and begin installation of plugin
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mv tmux.conf ~/.tmux.conf

#clone/update tldr library
tldr -u

#update bash_profile for zsh shell on kali
##remove profile from bash_profiles
sed -i '/PS1=/d' bash_aliases
sed -i '/nano=/d' bash_aliases
sed -i '/nbash=/d' bash_aliases
sed -i '/unset -f/d' bash_aliases
sed -i '/unset -f/d' bash_aliases
sed -i 's-source ~/.bashrc && source ~/.bash_aliases && source ~/Coding/Scripts/bash_aliases-source ~/.zshrc-' bash_aliases
sed 's#~/\.bash_aliases#~/.zshrc#' bash_aliases
sed 's#~/\Coding/Scripts/bash_aliases#~/.zshrc#' bash_aliases
sed 's#~/\Coding/Scripts/#~#' bash_aliases
sed 's#~linuxCheatSheet#~/linuxCheatSheet#' bash_aliases
sed 's#~securityCheatSheet#~/securityCheatSheet#' bash_aliases
sed 's#/home/jared/Coding/Scripts/linuxCheatSheet#~/linuxCheatSheet#' bash_aliases

#TODO: figure out why ~/.SwitchCaps doesn't affect input?
#temp solution to swap escape and caps lock:
echo "setxkbmap -option caps:swapescape" >> bash_aliases

sed -i '/^#local bash shortcuts/,/^#local bash shortcuts/d' bash_aliases
echo "#####NEW ALIASES/FUNCTIONS#####" >> ~/.zshrc
cat bash_aliases >> ~/.zshrc

#extend bash history to ~infity and beyond~
sed -i 's/SAVEHIST=2000/SAVEHIST=-1/' ~/.zshrc

#disable system beeps
sudo echo "blacklist pcspkr" >> /etc/modprobe.d/amd64-microcode-blacklist.conf
sudo echo "blacklist pcspkr" >> /etc/modprobe.d/intel-microcode-blacklist.conf
sudo rmmod pcspkr

#install autorecon
##install pipx to manage your python packages; 
###this installs each python package in it's own virtualenv, and makes it available in the global context, 
###which avoids conflicting package dependencies and the resulting instability
python3 -m pip install --user pipx
python3 -m pipx ensurepath
source ~/.zshrc

#Add the pipx binary path to the secure_path set in /etc/sudoers
sudo sed -i 's~sbin:/bin"~sbin:/bin:/home/kali/.local/bin"~' /etc/sudoers.d

#install packages used within autorecon
sudo apt install -y seclists curl enum4linux feroxbuster nbtscan nikto nmap onesixtyone oscanner smbclient smbmap smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf

#install autorecon
pipx install git+https://github.com/Tib3rius/AutoRecon.git



