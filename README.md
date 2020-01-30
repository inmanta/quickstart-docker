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
inmanta-cli environment create -n quickstart-env -p test -r https://github.com/inmanta/quickstart.git -b docker --save
```

4. Compile and immediatly deploy the quickstart project:  

`inmanta -vvv  export -d`

5. When deployment is complete, the drupal website is now reachable on `127.0.0.1:8080`  

## Using a dev version of inmanta

In the docker compose file you can find th build argument `inmanta_repo: inmanta_oss_stable.repo`.  
Changing this to `inmanta_repo: inmanta_oss_dev.repo` will make the quickstart use a dev release of inmanta instead.  

## Using the apache web-application-firewall

The web-app-firewall branch contains extra configs to allow for testing and tweaking of the WAP OWASP ruleset.  
It is based on the quickstart project but differs in 2 ways:

- The inmanta server does not share the quickstart-project directory
- An extra container with the apache proxy is added

### Setting up the WAF

First clone the quickstart-project:  

`git clone https://github.com/inmanta/quickstart.git --branch docker quickstart-project`

Then bring up the project:

```sh
docker-compose build
docker-compose up
```

The inmanta server is available on 172.28.0.3:8888, the apache proxy is available on port 443.
(and has a redirect to https on port 80)  
Next add inmanta.mydomain.com pointing to 172.28.0.6 to your hosts file.  

The dashboard should now be reachable at `https://inmanta.mydomain.com`.  
Now set up a test project and test environment:  

```sh
cd quickstart-project/
inmanta-cli project create -n test
inmanta-cli environment create -n quickstart-env -p test -r https://github.com/inmanta/quickstart.git -b docker --save
```

This created a .inmanta file.  
Open it and change it so it looks like this:  

```ini
[config]
fact-expire = 1800
environment={your_env_id}

[compiler_rest_transport]
host=inmanta.mydomain.com
port=443
ssl=true
ssl-ca-cert-file=../httpd/ssl/inmanta.crt

[cmdline_rest_transport]
host=inmanta.mydomain.com
port=443
ssl=true
ssl-ca-cert-file=../httpd/ssl/inmanta.crt
```

Now commands like inmanta export will use the WAP instead of localhost:8888

### Testing the WAP rules

OWASP rules are logged to apaches error_log, so to analyze it's output, attach a terminal to this file like so:

`docker exec -it inmanta_quickstart_proxy /bin/sh -c "tail -f /var/log/httpd/error_log"`

To change the rules simply attach a bash shell to the inmanta_quickstart_proxy container and edit the `/etc/httpd/modsecurity.d/owasp-modsecurity-crs/crs-setup.conf` file and the files in `/etc/httpd/modsecurity.d/owasp-modsecurity-crs/rules`.  

To make the changes take effect you will have to either send a reload signal to apache or stop and start the container. (Do not delete the container as this will reset the ruleset)
