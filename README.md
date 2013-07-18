# Setup scripts

This is a collection of setup scripts to use across the projects.
Setup scripts are used to speed up project's bootstrap time.

## Getting started

If you want to add *shetup* to your project, or you want to update existing
installation, just run this script:

    $ http://git.io/Kb7uuQ | bash

## Helpers

Here's the list of helpers and tools provided by the core scripts.

### `check_cmd`

Checks if given command is installed.

```sh
check_cmd git
check_cmd ruby 2.0.0
```

### `run`

Executes specified command or script:

```sh
run bundle install
run pip install -r requirements.txt
```

## Updating

If you want to update core scripts, run:

    $ https://github.com/nu7hatch/setup/tree/master/update.sh | bash

## Contributing

1. Fork the project.
2. Write awesome code (in a feature branch).
3. Test, test, test...!
4. Commit, push and send Pull Request.
