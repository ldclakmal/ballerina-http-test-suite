## Netty HTTP Echo Backend

A [Docker image](https://hub.docker.com/repository/docker/ldclakmal/netty-echo-backend) of Netty HTTP service which echo back the request payload. Supports both **HTTP/1.1** and **HTTP/2** versions and **SSL**. Also, supports any type of request payload such as text, json, xml etc.

#### Installed
1. Ubuntu 16.04
2. Netty 4.1.47.Final

### Run the image

- h1c - `$ docker run -d -p 8688:8688 ldclakmal/netty-echo-backend`
- h1 - `$ docker run -d -p 8688:8688 -e "SSL=true" ldclakmal/netty-echo-backend`
- h2c - `$ docker run -d -p 8688:8688 -e "HTTP2=true" ldclakmal/netty-echo-backend`
- h2 - `$ docker run -d -p 8688:8688 -e "HTTP2=true" -e "SSL=true" ldclakmal/netty-echo-backend`

---
### Test the image

- h1c - `$ curl -v http://localhost:8688 -d "Hello Netty!"`
- h1 - `$ curl -kv https://localhost:8688 -d "Hello Netty!"`
- h2c - `$ curl -v --http2 http://localhost:8688 -d "Hello Netty!"`
- h2 - `$ curl -kv --http2 https://localhost:8688 -d "Hello Netty!"`