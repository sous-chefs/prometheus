prometheus_install 'prometheus'

prometheus_config 'prometheus'

prometheus_job 'prometheus' do
  scrape_interval '15s'
  target 'localhost:9090'
end

prometheus_service 'prometheus'
