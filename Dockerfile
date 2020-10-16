FROM ubuntu:20.04
RUN apt-get update && apt-get install -y locales make git curl fonts-cmu inotify-tools python3-pip&& rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ARG DEBIAN_FRONTEND=noninteractive

COPY install-tex-without-doc.py /install-tex-without-doc.py
RUN apt-get update && apt-get install -y python3-pip && python3 /install-tex-without-doc.py && rm -rf /var/lib/apt/lists/*
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n && bash n lts

RUN mkdir -p /opt/svg2pdf && cd /opt/svg2pdf && npm i puppeteer
ADD svg2pdf.js /opt/svg2pdf/
RUN chmod +x /opt/svg2pdf/svg2pdf.js
RUN ln -s /opt/svg2pdf/svg2pdf /usr/bin/svg2pdf


RUN adduser --disabled-password --gecos '' developer

USER developer

RUN pip3 install numpy matplotlib pandas

CMD /bin/bash