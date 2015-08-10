# osquery-tls-server

A TLS endpoint for delivering osquery configuration files to nodes.

## Some features I'd like to have
get enroll secret from environment vars. Makes it easy to deploy the code
without having to stick a file into the repo.

Choose your config parameter. I might want to use a different configuration
for different kinds of servers. It would be cool to have a parameter that the
osquery nodes can set and have the server choose the right config for them.

## Helpful links

* The reference implementation in python: https://github.com/facebook/osquery/blob/master/tools/tests/test_http_server.py
* The documentation: https://github.com/facebook/osquery/blob/master/docs/wiki/deployment/remote.md
