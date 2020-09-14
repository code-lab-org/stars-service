# STARS Service
The STARS Service is a Python3 Flask REST webserver that interfaces with STARS COLLABORATE Simulation Libraries.  The STARS Service is deployed as a Docker container.  Currently, the STARS simulation codes are replaced with a temporary executable stub as development continues.  

### How to try it
First, clone the repository from GitHub:
```
git clone https://github.com/aobrien/stars-service.git
```
The stars-service Docker image is based on Ubuntu 20.04. The code comes with some scripts meant to be run on a Linux host.  Thus far, it is tested with Ubuntu 20.04.  To build the image, run:
```
./docker_build_stars_service.sh
```
Once built, run the stars-service in a container using:
```
./docker_run_stars_service.sh
```

The Dockerfile is curently set to use the host network and runs the webserver on port 8080. Note that the container is currently set to run in interactive mode during development.

A simple Python3 REST Client example program is provided to interface with the Webserve and exercise different functions.  To try it, run './client/test.py'

Alternatively, you can point a browser to 'http://localhost:8080/ui` to see the Swagger UI interface and explore the API.

