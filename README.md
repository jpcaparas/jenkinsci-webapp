# Jenkins CI for web apps

![Jenkins logo](http://i.imgur.com/CxLJ8ra.png)

## Overview
Before anything else, what is [Jenkins](https://jenkins.io/)? Here's a good answer from a [Quora question asking when and why it's used](https://www.quora.com/What-is-Jenkins-When-and-why-is-it-used):

> Jenkins is a Continuous Integration server.

> Basically Continuous Integration is the practice of running your tests on a non-developer machine automatically everytime someone pushes new code into the source repository.

> This has the tremendous advantage of always knowing if all tests work and getting fast feedback. The fast feedback is important so you always know right after you broke the build (introduced changes that made either the compile/build cycle or the tests fail) what you did that failed and how to revert it.

This is a Docker build that contains essential libraries for testing & building web applications on the Jenkins project configuration dialog:

- PHP 5.6
- Composer
- MariaDB 10
- node.js 7

These packages can be then be invoked as build steps using their respective binaries:

![Build steps](http://i.imgur.com/NESEqc5l.png)

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
1. The [official reference](https://docs.docker.com/engine/reference/run/) for the `docker run` command has plenty of options.

## TODO
- [ ] Caddy reverse proxy
- [ ] Caddy SSL (LetsEncrypt)
