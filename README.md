# Ballerina HTTP Test Suite

This is an HTTP test suite which contains followings as the resources.
- [Ballerina](https://ballerina.io) samples for a backend, client and gateway
- [JMeter](https://jmeter.apache.org/) scrips
- [Netty](https://netty.io/) backend
- Sample JSON payloads

### Compatibility

**Ballerina version:** 1.2.0

## How to run

First you have to create 3 instances for JMeter, Ballerina and Netty. If not you can run all in single instance.

### JMeter

- You can import and use the [JMX](./jmeter/) files for HTTP1.1 or HTTP2.0 as required.

### Ballerina

- Refer the [Getting Started](https://ballerina.io/learn/getting-started/) guide to download and install Ballerina.
- Run the particular [gateway](./ballerina/gateway/) *.bal* files by executing following command.

    `$ ballerina run <file_name.bal>`

### Netty

- You can run the Docker image of Netty Echo Backend as required.

    - h1c - `$ docker run -d -p 8688:8688 ldclakmal/netty-echo-backend`
    - h1 - `$ docker run -d -p 8688:8688 -e "SSL=true" ldclakmal/netty-echo-backend`
    - h2c - `$ docker run -d -p 8688:8688 -e "HTTP2=true" ldclakmal/netty-echo-backend`
    - h2 - `$ docker run -d -p 8688:8688 -e "HTTP2=true" -e "SSL=true" ldclakmal/netty-echo-backend`

- Refer the [Docker Hub Image](https://hub.docker.com/repository/docker/ldclakmal/netty-echo-backend) for more information.