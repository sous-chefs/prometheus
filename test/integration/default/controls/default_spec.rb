control 'prometheus' do
  impact 1.0
  title 'Prometheus is installed and managed by systemd'

  describe file('/opt/prometheus/prometheus.yml') do
    it { should exist }
    its('owner') { should eq 'prometheus' }
  end

  describe systemd_service('prometheus') do
    it { should be_enabled }
    it { should be_installed }
  end
end
