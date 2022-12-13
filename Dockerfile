FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.utf8
RUN apt-get update && apt-get install -y locales make git curl fonts-cmu inotify-tools python3-pip libappindicator1 libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 fonts-firacode && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

COPY install-tex-without-doc.py /install-tex-without-doc.py
RUN apt-get update && python3 /install-tex-without-doc.py && rm -rf /var/lib/apt/lists/*
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n && bash n lts

RUN mkdir -p /opt/svg2pdf && cd /opt/svg2pdf && npm i puppeteer
ADD svg2pdf.js /opt/svg2pdf/
RUN chmod +x /opt/svg2pdf/svg2pdf.js
RUN ln -s /opt/svg2pdf/svg2pdf.js /usr/bin/svg2pdf


RUN adduser --disabled-password --gecos '' developer

USER developer
ENV PATH="/home/developer/.local/bin:${PATH}"
RUN pip3 install numpy matplotlib pandas Pygments pygments-arm
CMD /bin/bash
