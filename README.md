# 🔥🦅 Falzar

<p align="center">
  <img width="160" src="https://static.wikia.nocookie.net/megaman/images/0/02/Fbeast-transparent.png/revision/latest?cb=20210831045650" />
</p>

Falzar is a background server mock which you can customize with whatever HTTP services, whenever you want. Open a console, run a command and boom, you have whatever endpoint you need mocked on your machine.

# Table of contents

- [Table of contents](#table-of-contents)
  - [Install and setup](#install-and-setup)
    - [Daemon config](#daemon-config)
    - [CLI config](#cli-config)
  - [Usage](#usage)
    - [Adding a new mock](#adding-a-new-mock)
    - [Deleting a mock](#deleting-a-mock)
    - [Browsing existing mocks](#browsing-existing-mocks)
  - [Roadmap](#roadmap)
  - [FAQ](#faq)

## Install and setup

First and foremost, you'll need to install [Haskell Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/). After that, clone this repository and run `bin/install`.

```
git clone git@github.com:despegar/aleperaltabazas/falzar.git
cd falzar/
bin/install
```

No need to run with sudo, the script will call sudo when it needs.

Once the script finishes, you'll now have the falzar daemon installed on your machine, which you can check with `systemctl status falzard.service`. By default, the daemon will be running on port 2305, but it can be customized by editing the configuration at `/etc/falzar/config.env` and reloading the daemon with `systemctl daemon-reload`. Make sure to mirror whatever changes you do in here in the CLI configuration at `~/.config/falzar.yaml` so the CLI still works.

The daemon is not enabled on startup by default. This behaviour can be added by running `systemctl enable falzard.service`.

As for interacting with the daemon, you can use the API directly if you desire so, but falzar also comes with a command line interface to simplify this interaction. Do read ahead to learn more about it.

### Daemon config

The daemon has two config files: the service file ([bin/falzard.service](bin/falzard.service)) and the env file for the service ([bin/config.env](bin/config.env)). The env file should specify the variables `PORT` and `DATA` that refer to the port in which the daemon will run and the folder to persist mocks.

After installing, by default, these will be at `/etc/falzar/config.env` and `/etc/systemd/system/falzard.service`.

### CLI config

The CLI config is at `~/.config/falzar.yaml` and specifies the port and host (in case you want to use a remote server mock).

## Usage

```
$> falzar --help
Customizable HTTP server mock

Usage: falzar COMMAND

Available options:
  -h,--help                Show this help text

Available commands:
  browse                   List active mocks
  register                 Register a new mock
  delete                   Delete a mock
```

### Adding a new mock

```
$> falzar register --help
Usage: falzar register (--data DATA | --file FILE | --no-response-body)
                       [--status STATUS] --path PATH --method METHOD

  Register a new mock

Available options:
  --data DATA              Response body for the mock
  --file FILE              File where the response body is stored
  --no-response-body       Set response body to null
  --status STATUS          Response status code (default 200)
  --path PATH              Service path
  --method METHOD          HTTP Method
  -h,--help                Show this help text
```

To add a mock, you'll need to use `falzar register`, which requires you to pass the path and method you want mocked, and an optional status which will default to 200. As for the body, you can choose to pass it as a literal string with the `--data` option, from a file with the `--file` option, or none at all, but you'll still need to specify this with the `--no-response-body` option.

If you need to update a mock, you can simply run the command with the same method and route and it'll replace the old one.

### Deleting a mock

```
Usage: falzar delete --path PATH --method METHOD

  Delete a mock

Available options:
  --path PATH              Path of the mock to delete
  --method METHOD          Method of the mock to delete
  -h,--help                Show this help text

```

### Browsing existing mocks

```
$> falzar browse --help
Usage: falzar browse [PATH]

  List active mocks

Available options:
  PATH                     Look for mocks with routes starting with <PATH>
  -h,--help                Show this help text
```

Show current falzar mocks. Example:

```
GET /test/2a6bb08e-d46a-4b58-81bc-880936c645e0
Status: 200
{
    "foo": [
        "bar",
        "baz",
        "biz",
        "qux",
        "quux",
        "corge",
        "grault",
        "garply",

...
(body truncated because it's too long)

POST /test
Status: 200
{
    "id": "foo",
    "message": "bar"
}
```

An optional `PATH` argument can be supplied to filter only the routes that start with said path.

## Roadmap

What's next for Falzar?

- GUI: a small frontend app to create mocks aside from the command line
- Profiles: switch between a local and a remote Falzar mock server
- Complex mock behaviour: check for path params, query params, headers and give different responses according to your needs for a more "real" mock

## FAQ
