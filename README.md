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

## Starting and stopping the lab

Building the whole environment is as easy as:  

`docker-compose up`

similarly, tearing it down is also quite simple:  

`docker-compose down`

Once the lab is up, you should be able to access (`127.0.0.1:8888`) and see the inmanta dashboard.  
You can use the dashboard to create a new project and environment.  
The steps below detail how to do it using the commandline.  

1. Attach a shell to the inmanta-server container:

`docker exec -it "inmanta_quickstart_server" bash`

2. Navigate to `/home/inmanta/quickstart-project/`. (This directory is shared with the host in this repo under ./quickstart-project)
3. Create the new project and environment:

```
inmanta-cli project create -n test
inmanta-cli environment create -n quickstart-env -p test -r https://github.com/inmanta/quickstart.git -b docker --save
```

4. Compile and immediatly deploy the quickstart project:

`inmanta -vvv  export -d`

5. When deployment is complete, the drupal website is now reachable on `127.0.0.1:8080`
