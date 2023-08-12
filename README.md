# 🔥🦅 Falzar

<p align="center">
  <img width="160" src="https://static.wikia.nocookie.net/megaman/images/0/02/Fbeast-transparent.png/revision/latest?cb=20210831045650" />
</p>

Falzar is a simple server mock, with the capacity to add and remove services at runtime. Open a console, run a command and boom, you have whatever endpoint you need mocked on your machine.

# Table of contents

- [Table of contents](#table-of-contents)
  - [Install and setup](#install-and-setup)
  - [Usage](#usage)
  - [FAQ](#faq)

## Install and setup

## Usage

```bash
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

```bash
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

### Browsing existing mocks

```bash
$> falzar browse --help
```

## FAQ
