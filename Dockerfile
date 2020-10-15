FROM ubuntu:20.04
RUN apt-get update && apt-get install -y locales sudo make git curl libxss-dev libasound2-dev fonts-cmu inotify-tools python3-pip&& rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ARG DEBIAN_FRONTEND=noninteractive

COPY install-tex-without-doc.py /install-tex-without-doc.py
RUN apt-get update && apt-get install -y python3-pip && python3 /install-tex-without-doc.py && rm -rf /var/lib/apt/lists/*
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n && bash n lts



RUN adduser --disabled-password --gecos '' developer
RUN adduser developer sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER developer
CMD /bin/bash


RUN pip3 install numpy matplotlib pandas
# RUN sudo apt-get update && sudo apt-get install -y poppler-utils && sudo rm -rf /var/lib/apt/lists/*
# RUN sudo apt-get update && sudo apt-get install -y libxcomposite1 libxcursor1 libxtst6 libgdk-pixbuf2.0-0 libgtk-3-0 && sudo rm -rf /var/lib/apt/lists/*