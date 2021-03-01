#!/bin/bash

# wait for inmanta dashboard to be up
until $(curl --output /dev/null --silent --head --fail http://localhost:8888/dashboard/#\\!/projects); do printf '.'; sleep 1; done

# create a project and environment, then export
sudo docker exec -i "inmanta_quickstart_server" sh -c "cd /home/inmanta/quickstart-project/; inmanta-cli project create -n test; inmanta-cli environment create -n quickstart-env -p test -r https://github.com/inmanta/quickstart.git -b docker --save"
sudo docker exec -i "inmanta_quickstart_server" sh -c "cd /home/inmanta/quickstart-project/; inmanta-cli environment setting set -e quickstart-env -k autostart_agent_deploy_splay_time -o 1"
sudo docker exec -i "inmanta_quickstart_server" sh -c "cd /home/inmanta/quickstart-project/; inmanta -vvv  export -d"

# wait for the deployment to be done
sudo docker exec -i "inmanta_quickstart_server" sh -c "cd /home/inmanta/quickstart-project/; while inmanta-cli version list -e quickstart-env | grep deploying; do sleep 1; done"

# Catch the logs
sudo docker logs inmanta_quickstart_server > server.log
sudo docker logs inmanta_quickstart_postgres > postgres.log
sudo docker exec -i "inmanta_quickstart_server" sh -c "cat /var/log/inmanta/resource-*.log" > resource-actions.log
sudo docker exec -i "inmanta_quickstart_server" sh -c "cat /var/log/inmanta/agent-*.log" > agents.log

# check if deployment was succesful
i=0
until $(curl --output /dev/null --silent --head --fail http://127.0.0.1:8080/install.php); do
   sleep 1;
   ((i=i+1))
   if [ $i -gt 10 ]; then
    exit 1
   fi
done