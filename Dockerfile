#利用するUbuntuのイメージ
FROM ubuntu:16.04

# 必要なパッケージのインストール
RUN apt update
RUN apt install -y unzip
RUN apt install -y cmake make
RUN apt install -y git
# install sshd
RUN DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openssh-server &&\
    apt-get -q autoremove 
RUN mkdir -p /var/run/sshd
 
RUN echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
RUN echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.1.0
RUN apt install curl
COPY ./.tool-versions /root/.tool-versions
RUN /root/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
RUN /root/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
RUN /root/.asdf/bin/asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
RUN /root/.asdf/bin/asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
RUN apt install -y libtinfo-dev libncurses5-dev
RUN apt install -y libssl-dev
RUN cd /root/ && /root/.asdf/bin/asdf install
RUN apt install -y inotify-tools
RUN echo '. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
RUN echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]
