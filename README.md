# osquery-tls-server

A TLS endpoint for delivering osquery configuration files to nodes. The quickest
way to get started is to [![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Running the server

For security purposes, the software requires new endpoints to supply a shared
secret which is found in an environment variable named NODE_ENROLL_SECRET.

To run the server run the following commands. The first two commands should only
need to be run once

```
bundle install
rake db:migrate
ruby server.rb
```

If you want to use the faster puma server you can run the app with this command:

```
puma -C puma.rb
```

Since this was written by a Heroku employee intending to run this on Heroku if
you run the app in production the code expects an environment variable named
DATABASE_URL with a url pointing to a postgres database. Absent that variable,
production mode will fall back to a postgres database on localhost.

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
--enroll_secret_path=/etc/osquery/osquery.secret
```

The lines above seem to be the minimum necessary to make osquery pull config
from a TLS endpoint. You will need to populate the `/etc/osqueryd/osqueryd.secret`
file with the value of your NODE_ENROLL_SECRET environment variable. Additional
lines that you may include in your osquery.flags file include:

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

## Enrolling osquery endpoints
The osquery endpoints will reach out to the TLS server and send a POST to `/api/enroll`
with a `node_secret` value that it read from it's own filesystem (`/etc/osquery/osquery.secret`
if you followed the `osquery.flags` file above). The value in that file must match
the node secret being used by the TLS server. The TLS server takes this value from an
environment variable named NODE_ENROLL_SECRET. If you have not set that variable
then it defaults to "valid_test".

If the server sends a valid node_secret then it will receive a node key that it
can use to pull its configuration from the server.

## Serving configuration files
The `osquery_configs` folder holds all the configuration files you want to send
to your osquery endpoints. At a minimum, you must have an osquery config file
in that folder named `default.conf`. This is the file that gets delivered to an
endpoint that sends a POST request to `/api/config` and is also the fallback
configuration if an endpoint sends a POST request to a named path that doesn't
have an associated file (`/api/config/unknown`)

You can serve different configuration files to different server types by putting
multiple configuration files into the `osquery_configs` folder and configuring your
osquery endpoints with a different `config_tls_endpoint` value in `/etc/osquery/osquery.flags`.
The TLS server will try to match the name of the endpoint with the name of a file.
If your osquery endpoint sends a POST request to `/api/config/blahblahblah` then the
TLS server will look in `osquery_configs` for a file named blahblahblah.conf.

## Helpful links

* The reference implementation in python: https://github.com/facebook/osquery/blob/master/tools/tests/test_http_server.py
* The documentation: https://github.com/facebook/osquery/blob/master/docs/wiki/deployment/remote.md

## Running tests

The tests are written in RSpec and make use of the `rack-test` gem. If you do a
`bundle install` you should have that. Since the application uses a database to
keep track of node_keys, you'll need to prepare the database before the first
time you run the tests. `RACK_ENV=test rake db:migrate`. It shouldn't be that way
and there is a bug waiting to be fixed: https://github.com/blackfist/windmill/issues/8

So you can just run `rspec spec` to run
the tests.
