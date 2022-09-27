# The assistant shell command images
The commands directory contains the assistant needed shell commands to behave as expected.
```
The shell commands are the commands you can access from the os directly by writing its name e.g. 'ls'
```
You may add new commands to the directory and run the following to deploy your command to the OS.
```
./deploy.sh
```
### Docker
Docker has different directory for the assistant command, please use one of the below mention command for deploy the assistant command on the docker image.
```
./deploy.sh -d   OR  ./deploy.sh -docker
```

### Details
The previous shell script file copies all the commands added in this file to the commands base directory `~/.local/bin` <br>
After running the `deploy.sh` shell script you may access your command using the OS terminal by writing the command name.
You can find the `noisesup` command file as an example on how the system command should look like. <br>
