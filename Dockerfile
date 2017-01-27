#利用するUbuntuのイメージ
FROM ubuntu:16.04

# 必要なパッケージのインストール
RUN apt update
RUN apt install -y unzip cmake make git xz-utils liblzma-dev
# install sshd
RUN DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openssh-server &&\
    apt-get -q autoremove
RUN mkdir -p /var/run/sshd

RUN echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
RUN echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
RUN apt-get install -y curl libtinfo-dev libncurses5-dev libssl-dev inotify-tools
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.1.0
ADD ./tool-versions /root/.tool-versions
RUN /root/.asdf/bin/asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
RUN /root/.asdf/bin/asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
RUN /root/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
RUN /root/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
RUN cd /root/ && /root/.asdf/bin/asdf install && rm -rf /tmp/*
RUN echo '. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
RUN echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile
ENV PATH=/root/.asdf/bin:/root/.asdf/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mix local.hex --force && mix local.rebar --force
RUN gem install bundler compass

# Standard SSH port
EXPOSE 8080
