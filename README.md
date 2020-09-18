# STARS Service - REST API Implementation

**STARS COLLABORATE** is a C++ library for simulation of constellations of adaptive and collarborate satellite systems.  

The **STARS Service** is an HTTP-based RESTful web service that provides a simple way for users to run STARS COLLABORATE simulations.  The API provides functionality for long-running jobs, which are submitted, managed, and deleted.  Jobs produce simulation output data that can be downloaded and deleted through the service.  

The code is divided into a server and client side.  Server side implementation is based on Python3 using Flask & Connexion running in a Docker container.  Client side test scripts for the API are provided as simple Python3 examples.  

The API is formally defined in Swagger YAML.  Alternatively, it can be explored online at [STARS-Service on SwaggerHub](https://app.swaggerhub.com/apis/aobrien/STARS-Service)

## Configuring a Simulation with JSON

A simulation job is created by submitting a JSON-formatted  simulation configuration. 

Please see [JSON Format Wikipage](https://github.com/aobrien/stars-service/wiki/JSON-Format-for-STARS-Simulation-Configuration) for the latest JSON format information.

## Building & Running STARS Service Container

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

## Testing the STARS Service with a Client

A simple Python3 REST Client example program is provided to interface with the Webserve and exercise different functions.  To try it, 
```
./client/test.py
```

Alternatively, you can point a browser to 'http://localhost:8080/ui` to see the Swagger UI interface and explore the API.

---

*Authors: Andrew O'Brien & Ryan Linnabary*
