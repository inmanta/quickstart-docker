# Quickstart using Docker

This project is part of the [Quickstart guide for the Inmanta automation and orchestration tool](https://docs.inmanta.com/community/latest/quickstart.html).  

NOTE:
This quickstart is only meant to try out inmanta.
The 2 agent containers emulate centos hosts but are not the real things and thus have several limitations.  
It is strongly discouraged to run the inmanta-agents in this manner.  

## Requirements

All you need is docker and docker-compose.  

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

2. Navigate to `/home/inmanta/test-project/`. (This directory is shared with the host in this repo under ./test-project)
3. Create the new project and environment:

```
inmanta-cli project create -n test
inmanta-cli environment create -n quickstart-env -p test --save
```

4. Compile and immediatly deploy the test project:

`inmanta -vvv  export -d`

The progress can be checked using the dashboard.

5. If everything deployed correctly, the drupal based website should be reachable on `127.0.0.1:8080`
