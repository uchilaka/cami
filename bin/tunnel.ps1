# Accomplish something that looks like this:
# ngrok start --all --config=config/ngrok.yml
#
# Issues to resolve:
# 1. Configure Windows to use Direnv to load the environment variables from the .env.local file.
# 2. Resolve the issues with the ExecutionPolicy to allow running the script. Determine the right one
#    and update the README.md to instruct devs to set it up before attempting to start the tunnel.
#
# Start tunnel
ngrok start --all --config "\\wsl$\Ubuntu-22.04\home\localadmin\repos\@larcity\cami\config\ngrok.yml"
