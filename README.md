# Jenkins CI for web apps

![Jenkins logo](http://i.imgur.com/CxLJ8ra.png)

## Overview
A Docker image that contains essential libraries for testing web applications on a shell:  
- PHP 5.6
- MariaDB 10
- node.js 7

## System requirements
1. Docker running on your machine.
1. At least 1GB RAM.

## Running the Docker image as a container
1. Run `docker run -d -p 8000:8080 -p 50000:50000 -v [dir-on-host-machine]:/var/jenkins_home jpcaparas/jenkinsci-webapp`.
    - The `-d` flag runs it on detached mode (in the background).
    - The `-p` flag sets port mappings between host and container.
    - The `-v` flag sets volume bindings between host and container. This means that files & folders on `dir-on-host-machine` directory (which is mapped to `/var/jenkins_home` on the container, containing Jenkins data), will **not be wiped** when the container is stopped or rebuilt, preserving configuration, plugins, build data, etc.
    - `jpcaparas/jenkinsci-webapp` is the [image hosted on Docker Hub](https://hub.docker.com/r/jpcaparas/jenkinsci-webapp/).
    - Make sure `dir-on-host-machine` is writable by the `jenkins` user and `group`.
1. Go to http://[hostname]:8000 and follow installation steps.

## Resources
1. This build is based off of the [Official Jenkins Docker build](https://github.com/jenkinsci/docker).
