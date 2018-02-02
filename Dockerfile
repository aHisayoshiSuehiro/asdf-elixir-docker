#利用するUbuntuのイメージ
FROM ubuntu:16.04

ENV LANG=ja_JP.utf8
ENV GNUPGHOME="$HOME/.asdf/keyrings/nodejs"
RUN mkdir -p "$GNUPGHOME" && chmod 0700 "$GNUPGHOME"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D ;\
    gpg --keyserver pool.sks-keyservers.net --recv-keys 94AE36675C464D64BAFA68DD7434390BDBE9B9C5 ;\
gpg --keyserver pool.sks-keyservers.net --recv-keys FD3A5288F042B6850C66B31F09FE44734EB7990E ;\
gpg --keyserver pool.sks-keyservers.net --recv-keys 71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 ;\
gpg --keyserver pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D ;\
gpg --keyserver pool.sks-keyservers.net --recv-keys C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 ;\
gpg --keyserver pool.sks-keyservers.net --recv-keys B9AE9905FFD7803F25714661B63B535A4C206CA9 ;\
gpg --keyserver pool.sks-keyservers.net --recv-keys 56730D5401028683275BD23C23EFEFE93C4CFFFE
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
RUN apt-get install -y curl libtinfo-dev libncurses5-dev libssl-dev inotify-tools libexpat1-dev autoconf
RUN rm -rf ~/.asdf; git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.1
ADD ./tool-versions /root/.tool-versions
RUN /root/.asdf/bin/asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
RUN /root/.asdf/bin/asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
RUN /root/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
RUN /root/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
RUN cd /root/ && /root/.asdf/bin/asdf install erlang 20.2.2 && /root/.asdf/bin/asdf install elixir 1.5.3 && /root/.asdf/bin/asdf install ruby 2.3.1 && /root/.asdf/bin/asdf install nodejs 6.12.3 && rm -rf /tmp/*
RUN echo '. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
RUN echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile
ENV PATH=/root/.asdf/bin:/root/.asdf/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mix local.hex --force && mix local.rebar --force
RUN gem install bundler compass

# Standard SSH port
EXPOSE 8080
