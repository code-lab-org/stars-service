FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y g++
RUN apt install -y python3-pip
RUN pip3 install connexion[swagger-ui]==2.6
RUN pip3 install python_dateutil==2.6.0
RUN pip3 install setuptools>=21.0.0
RUN pip3 install werkzeug

EXPOSE 8080

VOLUME /workspace

COPY server /server

RUN ln -sf /workspace/out /server/out

WORKDIR /server
CMD ["/server/cmd.sh"]

# make interactive for debugging
# CMD /bin/bash

