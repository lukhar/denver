FROM base/archlinux

RUN echo '[archlinuxfr]' >> /etc/pacman.conf && \
    echo 'SigLevel = Never' >> /etc/pacman.conf && \
    echo 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf && \
    sed -i "s/^SigLevel.*/SigLevel = Never/g" /etc/pacman.conf

RUN pacman --noconfirm -Syyu && pacman-db-upgrade && \
    pacman --noconfirm -S yaourt

RUN yaourt --noconfirm -S \
    vim \
    neovim \
    python2 \
    python2-pip \
    python2-neovim \
    python \
    python-pip \
    python-neovim \
    python-virtualenvwrapper\
    git \
    openssh \
    tmux \
    cmake \
    base-devel \
    fzf \
    sudo

RUN useradd -r -g wheel lukhar
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

WORKDIR /home/lukhar
RUN chown -R lukhar:wheel /home/lukhar
USER lukhar

RUN yaourt --noconfirm -Sy universal-ctags-git

RUN git config --global url."https://github.com/".insteadOf git@github.com: && \
    git clone --recursive https://github.com/lukhar/.config.git && \
    git clone https://github.com/lukhar/.vim && \
    sh ~/.config/bootstrap.sh

RUN source /usr/bin/virtualenvwrapper.sh && \
    mkvirtualenv -p python2 python2 && \
    vim +PlugInstall +qall

ENTRYPOINT /bin/bash
