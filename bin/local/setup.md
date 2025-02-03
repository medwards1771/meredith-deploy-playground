# Setup

1. Create server + affiliated resources in infra/main.tf with `terraform apply`
1. Add new instance's public IPv4 DNS to local ~/.ssh/config and webserver.txt
1. Run `bin/local/install_system_dependencies <server-nickname>`
    - you gotta run this twice the first time docker is installed
    - TODO: Prevent script from exiting after installing docker
    - Possibly a resource limit issue, try `dmesg` and `ulimit -a` to debug
    - Assign agent token in /etc/buildkite-agent/buildkite-agent.cfg
    - Set DOCKER_LOGIN_PASSWORD env var in /etc/buildkite-agent/hooks/environment
1. Run `bin/local/install_kubernetes_and_friends.sh <server-nickname>`
    - ssh onto the web server and run the command inside `bin/local/k8s/docker-credentials-secret.txt`
1. Modify the server > location > proxy_pass value in `docker/nginx/nginx.conf` to match the new instance's enp39s0 IPv4 address
1. Test a deploy!
