FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME /workspace
WORKDIR /workspace

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y sssd libnss-sss
RUN apt-get install -y silversearcher-ag

COPY nsswitch.conf /etc/nsswitch.conf

RUN chmod 0644 /etc/nsswitch.conf
RUN apt-get install -y python3-pip

RUN pip3 install connexion[swagger-ui]==2.6
RUN pip3 install python_dateutil==2.6.0
RUN pip3 install setuptools>=21.0.0
RUN pip3 install werkzeug

EXPOSE 8080

CMD /bin/bash
