# Quickstart using Docker

This project is part of the [Quickstart guide for the Inmanta automation and orchestration tool](https://docs.inmanta.com/community/latest/quickstart.html).  

NOTE:
This quickstart is only meant to try out inmanta.
The 2 agent containers emulate centos hosts but are not the real thing and thus have several limitations.  
It is strongly discouraged to run the inmanta-agents in this manner.  

## Requirements

All you need is docker and docker-compose.  
Optionally you can use the inmanta quickstart project and clone it in to the quickstart-project directory:  

`git clone https://github.com/inmanta/quickstart.git --branch docker quickstart-project`

The quickstart-project directory will be mounted in to the server container under `/home/inmanta/quickstart-project/`

If you are on `Windows` you have to make sure you also do the following:

- In Powershell: `$env:COMPOSE_CONVERT_WINDOWS_PATHS = 1`
- Restart Docker for Windows
- Go to Docker for Windows settings > Shared Drives > Reset credentials > select drive with quickstart project > set your credentials > Apply

## Starting and stopping the lab

Building the whole environment is as easy as:  

`docker-compose up`

similarly, tearing it down is also quite simple:  

``` sh
docker-compose down
docker volume prune -f
```

Once the lab is up, you should be able to access (`127.0.0.1:8888`) and see the inmanta dashboard.  
You can use the dashboard to create a new project and environment.  
The steps below detail how to do it using the commandline.  

1. Attach a shell to the inmanta-server container:  

`docker exec -it "inmanta_quickstart_server" bash`

2. Navigate to `/home/inmanta/quickstart-project/`. (This directory is shared with the host in this repo under ./quickstart-project)  
3. Create the new project and environment:  

```
inmanta-cli project create -n test
inmanta-cli environment create -n quickstart-env -p test -r https://github.com/inmanta/quickstart.git --save
```

4. Compile and immediatly deploy the quickstart project:  

`inmanta -vvv  export -d`

5. When deployment is complete, the drupal website is now reachable on `127.0.0.1:8080`  

## Configuration options

By default, quickstart-docker runs on the latest stable release of inmanta OSS product using a Centos 7 container. This 
behavior can be 
adjusted by setting environment variables. The following environment variables can be set:

| Environment variable   | Allowed values      | Default value  | Description                                               |
| :--------------------: |:-------------------:| :-------------:| --------------------------------------------------------- |
| EL_VERSION             | [7, 8]              | 7              | Run the inmanta orchestrator on this Centos version       | 
| RELEASE                | [dev, next, stable] | stable         | Install the inmanta orchestrator from this release stream |

**Example:** Run quickstart-docker on a Centos 8 container using the latest development release of inmanta OSS product.

```bash
$ export EL_VERSION=8
$ export RELEASE=dev
$ docker-compose up
```
