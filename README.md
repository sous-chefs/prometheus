# prometheus Cookbook

This cookbook provides custom resources for installing and configuring [Prometheus][] and Alertmanager.

## Requirements

* Chef Infra Client 16.0 or later
* A systemd Linux platform listed in [LIMITATIONS.md](LIMITATIONS.md)

See [LIMITATIONS.md](LIMITATIONS.md) for upstream platform and installation constraints.

## Resources

* [prometheus_install](documentation/prometheus_install.md)
* [prometheus_config](documentation/prometheus_config.md)
* [prometheus_service](documentation/prometheus_service.md)
* [prometheus_job](documentation/prometheus_job.md)
* [prometheus_alertmanager_install](documentation/prometheus_alertmanager_install.md)
* [prometheus_alertmanager_config](documentation/prometheus_alertmanager_config.md)
* [prometheus_alertmanager_service](documentation/prometheus_alertmanager_service.md)

See [migration.md](migration.md) for migration notes from the legacy recipe and attribute interface.

## Usage

```ruby
prometheus_install 'prometheus'

prometheus_config 'prometheus'

prometheus_job 'prometheus' do
  scrape_interval '15s'
  target 'localhost:9090'
end

prometheus_service 'prometheus'
```

Alertmanager:

```ruby
prometheus_alertmanager_install 'alertmanager'
prometheus_alertmanager_config 'alertmanager'
prometheus_alertmanager_service 'alertmanager'
```

## License & Authors

* Author: Ray Rodriguez <rayrod2030@gmail.com>
* Author: kristian järvenpää <kristian.jarvenpaa@gmail.com>
* Maintainer: Sous Chefs

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[Prometheus]: https://github.com/prometheus/prometheus
