FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y g++
RUN apt install -y python3-pip
RUN pip3 install connexion[swagger-ui]==2.6
RUN pip3 install python_dateutil==2.6.0
RUN pip3 install setuptools>=21.0.0
RUN pip3 install werkzeug

# Linux Packages for STARS COLLABORATE
RUN apt install -y mpv
RUN apt install -y wget
RUN apt install -y cmake
RUN apt install -y make
RUN apt install -y doxygen
RUN apt install -y python3
RUN apt install -y libcanberra-gtk3-module
RUN apt install -y ffmpeg
RUN apt install -y libgeos-dev
RUN apt install -y graphviz
RUN apt install -y python3-tk
RUN apt install -y man
RUN apt install -y libproj-dev
RUN apt install -y proj-data
RUN apt install -y proj-bin
RUN apt install -y texlive-latex-extra
RUN apt install -y libnetcdf-dev

# Python Packages for STARS COLLABORATE
RUN pip3 install doxypypy
RUN pip3 install pylint
RUN pip3 install cpplint
RUN pip3 install scipy
RUN pip3 install cython
RUN pip3 install netcdf4
RUN pip3 install matplotlib
RUN pip3 install pypdf2
RUN pip3 install pandas
RUN pip3 install pillow
RUN pip3 install cartopy

EXPOSE 8080

# build STARS COLLABORATE (draft)
RUN wget https://github.com/aobrien/stars-collaborate/archive/master.zip
RUN unzip master.zip
RUN cd stars-collaborate-master; mkdir build; cd build; cmake ..; make

COPY server /server

# TODO: find way to make data persistent
# VOLUME /workspace

# TODO: find way to make data persistent
# RUN ln -sf /workspace/out /server/out

WORKDIR /server
CMD ["/server/cmd.sh"]

# make interactive for debugging
# CMD ["/bin/bash"]

