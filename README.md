# STARS Service - REST API Implementation

**STARS COLLABORATE** is a C++ library for simulation of constellations of adaptive and collarborate satellite systems.  The library was orginally developed by Ryan Linnabary and distributed on GitHub [here](https://github.com/linnabary/collaborate).  A new version has been [forked](https://github.com/aobrien/stars-collaborate) and forms the basis for this service.  

The **STARS Service** is an HTTP-based RESTful web service that provides a simple way for users to run STARS COLLABORATE simulations.  The API provides functionality for long-running jobs, which are submitted, managed, and deleted.  Jobs produce simulation output data that can be downloaded and deleted through the service.  The code in this repo is divided into a server and client side.  The server side API implementation is in Python3 utilizing Flask & Connexion and running in a Docker container.  The client side test scripts for the API are provided as simple Python3 examples.  

The **STARS-Service API** is formally defined in Swagger YAML and can be explored online at [STARS-Service on SwaggerHub](https://app.swaggerhub.com/apis/aobrien/STARS-Service)

## Configuring a Simulation with JSON

A simulation job is created by submitting a JSON-formatted simulation configuration. 

Please see [JSON Format Wikipage](https://github.com/aobrien/stars-service/wiki/JSON-Format-for-STARS-Simulation-Configuration) for the latest JSON format information.

## Building & Running STARS Service Container

First, clone this repository from GitHub:
```
git clone https://github.com/aobrien/stars-service.git
```
Next, you will need to build the stars-service Docker image.  The image is currently based on Ubuntu 20.04, although future work will emphasize a lightweight base.  Two shell scripts are provided for building and running the container on a Linux host (note, it has only been tested with Ubuntu 20.04).  

To build the stars-service image, run:
```
./docker_build_stars_service.sh
```
Once built, run the stars-service in a container using:
```
./docker_run_stars_service.sh
```

The Stars Service Dockerfile is curently configured to use the host network and runs the webserver on port 8080. 

## Testing the STARS Service with a REST Client

A simple Python3 REST Client example program is provided to interface with the Webserve and exercise different functions.  To try it, 
```
./client/test.py
```

Additionally, you can point a browser to 'http://localhost:8080/ui` to see the Swagger UI interface and explore the API.

---

*Authors: Andrew O'Brien & Ryan Linnabary, 2020*
