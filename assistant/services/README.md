# Services directory usage

### Package description
The services (files with .service extension) inside the system_services and user_services are required to run the system automatically, whenever the hardware device gets turned on, without explicitly turning on the system functionalities of the assistant.

### How to set up the services

#### First give permission to access the services and thier helpers content by running the following

```
sudo chmod -R 777 /services /services/helpers /services/user_services /services/system_services
```

#### Then run the following command to copy the system services to the OS

```
./deploy.sh
```

#### Now you have all of the required assistant services installed on your machine.

### Services state

#### You can use the `system_service.sh` script to view the status of the assistant system services.

#### Get all the services state

```
./system_services.sh status
```

#### Get one services state

```
./system_services.sh status assistant-face-local-run
```

#### Get n services state

```
./system_services.sh status assistant-face-local-run assistant-qa
```

#### Note that if you miss-spilled any of the system services name, all the system services state will be printed in order to avoid any unexpected exception.

#### Restart all the system services

```
./system_services.sh restart
```

#### Restart specific system services

```
./system_services.sh restart assistant-face-local-run
```

#### You can apply any of the following commands on the system_services.sh : `start`, `stop`, `restart`, `status`, `enable`

#### If you provided any service name to the script along with your intended command, the script will apply the command on the provided arguments only. Instead of applying the command on all the system services.

#### If you chose not to provide any service name, then the provided command will be applied on all of the system services.
