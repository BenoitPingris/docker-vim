FROM archlinux:latest

# Base installation
RUN pacman -Syyu --noconfirm --noprogressbar && \
    pacman -S --noconfirm --needed --noprogressbar \
    base-devel git nodejs npm ripgrep

# # Add user, group sudo
# RUN /usr/sbin/groupadd --system sudo && \
#     /usr/sbin/useradd -m --groups sudo user && \
#     /usr/sbin/sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
#     /usr/sbin/echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install yay - https://github.com/Jguer/yay
ENV yay_version=10.3.0
ENV yay_folder=yay_${yay_version}_x86_64
RUN cd /tmp && \
    curl -L https://github.com/Jguer/yay/releases/download/v${yay_version}/${yay_folder}.tar.gz | tar zx && \
    install -Dm755 ${yay_folder}/yay /usr/bin/yay && \
    install -Dm644 ${yay_folder}/yay.8 /usr/share/man/man8/yay.8

# Install neovim
RUN yay -S --noconfirm neovim

# Install dotfiles and setup neovim
RUN git clone https://github.com/BenoitPingris/dotfiles ~/dotfiles && \
    mkdir ~/.config -p && cp -r ~/dotfiles/nvim  ~/.config && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' && \
       nvim --headless +PlugInstall +qa


# Set correct locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8
ENV LC_CTYPE 'en_US.UTF-8'
