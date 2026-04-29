# Migration

This cookbook has been migrated from recipes and attributes to custom resources.

## Removed Entry Points

The `recipes/` and `attributes/` directories were removed. Wrapper cookbooks should call the resources directly and pass property values instead of overriding `node['prometheus']` attributes.

Legacy runit, upstart, and SysV init behavior was removed. Services are managed with Chef's `systemd_unit` resource.

## Resource Mapping

Use these resources in place of the old recipes:

* `prometheus_install` replaces `prometheus::binary`, `prometheus::shell_binary`, and `prometheus::source`.
* `prometheus_config` replaces the Prometheus configuration portion of `prometheus::default`.
* `prometheus_service` replaces `prometheus::service`.
* `prometheus_alertmanager_install` replaces `prometheus::alertmanager_binary` and `prometheus::alertmanager_source`.
* `prometheus_alertmanager_config` replaces the Alertmanager configuration portion of `prometheus::alertmanager`.
* `prometheus_alertmanager_service` replaces the Alertmanager service portion of `prometheus::alertmanager`.
* `prometheus_job` remains available and now uses explicit properties instead of node attributes.

## Example

```ruby
prometheus_install 'prometheus'

prometheus_config 'prometheus'

prometheus_job 'prometheus' do
  scrape_interval '15s'
  target 'localhost:9090'
end

prometheus_service 'prometheus'
```
