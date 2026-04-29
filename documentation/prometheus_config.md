# prometheus_config

Writes the Prometheus configuration file.

## Actions

* `:create`
* `:delete`

## Properties

Common properties include `config_file`, `template_cookbook`, `template_source`, `rule_filenames`, `global_config`, `allow_external_config`, `user`, and `group`.

`prometheus_job` resources update the same template resource through the accumulator pattern.
