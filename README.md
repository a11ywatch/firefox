# firefox

Firefox instance and panel WIP

## Usage

1. Can spawn multiple firefox instances.
1. Get firefox ws connections and status.

The current instance binds firefox to 0.0.0.0 when starting via API.

Use the env variable `REMOTE_ADDRESS` to change the address of the chrome instance between physical or network.

The application will pass alp health checks when using port `6001` to get the status of the chrome container.

A side loaded application is required to run chrome on a load balancer, one of the main purposes of the control panel.

Firefox starts on port `5800`.

In order to get the firefox port inside the container make a GET request to port `6001`.

## Building without Docker

In order to build without docker set the `BUILD_FIREFOX` env var to true.