`docker build -t erlang-server .`

`docker run --publish 4000:4000 --name erlang-server erlang-server`

`docker stop erlang-server`

`docker rm erlang-server`
