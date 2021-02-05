# Pushing Cloud Events to InfluxDB

[![CI](https://github.com/drogue-iot/drogue-influxdb-pusher/workflows/CI/badge.svg)](https://github.com/drogue-iot/drogue-influxdb-pusher/actions?query=workflow%3A%22CI%22)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/tag/drogue-iot/drogue-influxdb-pusher?sort=semver)](https://github.com/orgs/drogue-iot/packages/container/package/drogue-influxdb-pusher)
[![Matrix](https://img.shields.io/matrix/drogue-iot:matrix.org)](https://matrix.to/#/#drogue-iot:matrix.org)

Extracts information from JSON based cloud events and pushes them to InfluxDB.

## Input

Cloud event:

* **Data Content Type**: Mime type of the payload, must be `application/json`
* **Payload**: JSON payload from which to extract values.

## Output

There is no output. The result will be written to the configured InfluxDB instance.

## Payload

The application expects a JSON payload structure, from which it extracts fields and tags using *JSON path* expressions.

## Configuration

You can use the following environment variables to configure its behavior:

| Name | Required | Default | Description |
| ---- | -------- | ------- | ----------- |
| `BIND_ADDR` | | `127.0.0.1:8080` | The address the HTTP server binds to |
| `RUST_LOG` | | none | The configuration of the logger, also see https://docs.rs/env_logger/latest/env_logger/ |
| `INFLUXDB_URI`| x | none | The URI of the InfluxDB instance to connect to |
| `INFLUXDB_DATABASE` | x | none | The name of the InfluxDB database to write to |
| `INFLUXDB_USERNAME` | | none | The username used to login in to database instance |
| `INFLUXDB_PASSWORD` | | none | The password used to login in to database instance |
| `INFLUXDB_TABLE` | x | none | The table to write to |

Additionally, you need to configure a set of fields and (optionally) some tags, which make up the write query. Both
are configured using environment variables. Fields are prefixed with `FIELD_` and tags are prefixed with `TAG_`.

JSON paths for both fields and tags must result in a single element. Queries which end up with no fields will not
be executed.

Fields and tags will be converted to lowercase before writing.

Paths for fields are rooted to the data section of the cloud event. Paths for tags are rooted at the JSON
representation of the cloud event.

### Examples

The following example defines a field (named `temperature`), which will take the value from the field `temp` of the
data section of the cloud events:

~~~yaml
- name: FIELD_TEMPERATURE
  value: $.temp
~~~

For each field, you can also configure the expected type, the default is to try and auto-convert the value:

~~~yaml
- name: TYPE_FIELD_TEMPERATURE
  value: float
~~~

The types correspond to the InfluxDB types. The following types are available:

<dl>
    <dt><code>none</code> (the default)</dt> <dd>Try auto-conversion. For numbers, this will try a float first, then fall back to signed, and then to unsigned integers.</dd>
    <dt><code>float</code>, <code>number</code></dt> <dd>Floating point value</dd>
    <dt><code>string</code>, <code>text</code></dt> <dd>Text value</dd>
    <dt><code>bool</code>, <code>boolean</code></dt> <dd>Boolean value</dd>
    <dt><code>int</code>, <code>integer</code></dt> <dd>Signed integer value</dd>
    <dt><code>uint</code>, <code>unsigned</code></dt> <dd>Unsigned integer value</dd>
</dl>

If a value cannot be converted, and error is raised.

The following example defines a tag (named `device_id`), which will take the value from the cloud events attribute
`subject`:

~~~yaml
- name: TAG_DEVICE_ID
  value: $.subject
~~~

## Building

You can build the container image using:

~~~shell
cargo build --release
docker build . -t drogue-influxdb-pusher
~~~
