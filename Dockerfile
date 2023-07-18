FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get install -y wget python3 python3-pyqt5 python3-pyqt5.qtwebkit libqt5svg5 python3-lxml zlib1g python3-enchant python3-markdown pandoc sudo
RUN wget --no-check-certificate -q -O /tmp/manuskript-0.15.0-1.deb https://github.com/olivierkes/manuskript/releases/download/0.15.0/manuskript-0.15.0-1.deb \
    && dpkg -i /tmp/manuskript-0.15.0-1.deb \
    && rm /tmp/manuskript-0.15.0-1.deb

#Add new sudo manuskript user
ENV USERNAME manuskript-user
RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    # Replace 1000 with your user/group id
    usermod  --uid 1000 $USERNAME && \
    groupmod --gid 1000 $USERNAME
USER $USERNAME
CMD /usr/bin/manuskript
