# stars-service
The STARS Service is a Python3 Flask REST webserver that runs in a separate Docker container.  Currently, the STARS COLLABORATE Simulation code is replaced with a temporary stub as development continues.  
```
git clone https://github.com/aobrien/stars-service.git
```
The stars-service image is based on Ubuntu 20.04. To build the image, run:
```
./docker_build_stars_service.sh
```
Once built, run the stars-service in a container using:
```
./docker_run_stars_service.sh
```

The Dockerfile is curently set to use the host network and run the webserve on port 8080. The container is currently set to run in interactive mode during development.  To test the REST API, in a separate terminal, run  './client/test.py'

Alternatively, you can point a browser to 'http://localhost:8080/ui` to see the Swagger UI interface and explore the API.

