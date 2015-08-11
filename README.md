# osquery-tls-server

A TLS endpoint for delivering osquery configuration files to nodes.

## Running the server

To run the server just do `bundle install` and then `ruby server.rb`

## Configuring osqueryd

The easiest way to configure osqueryd is to put your command line options
into a flag file. By default on linux systems, osqueryd will look for
`/etc/osquery/osquery.flags` You need to have the following options set there
for osqueryd to look to your server.

```
--tls_hostname=dns.name.of.your.server.with.no.https.on.the.front.com
--config_plugin=tls
--config_tls_endpoint=/api/config
--config_tls_refresh=14400
--enroll_tls_endpoint=/api/enroll
--enroll_secret_path=/etc/osquery.secret
```

The lines above seem to be the minimum necessary to make osquery pull config
from a TLS endpoint. Additional lines that you may include in your osquery.flags
file include:

```
--database_path=/var/osquery/osquery.db
--schedule_splay_percent=10
--logger_plugin=syslog
--logger_syslog_facility=3
--log_results_events=true
--verbose
```

Then you can start osqueryd (on linux) with a simple `/etc/init.d/osqueryd start`
or `service start osqueryd`

## Some features I'd like to have
get enroll secret from environment vars. Makes it easy to deploy the code
without having to stick a file into the repo.

Choose your config parameter. I might want to use a different configuration
for different kinds of servers. It would be cool to have a parameter that the
osquery nodes can set and have the server choose the right config for them.

## Helpful links

* The reference implementation in python: https://github.com/facebook/osquery/blob/master/tools/tests/test_http_server.py
* The documentation: https://github.com/facebook/osquery/blob/master/docs/wiki/deployment/remote.md

## Running tests

The tests are written in RSpec and make use of the `rack-test` gem. If you do a
`bundle install` you should have that. So you can just run `rspec spec` to run
the tests.
