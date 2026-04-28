control 'alertmanager' do
  impact 1.0
  title 'Alertmanager is installed and managed by systemd'

  describe file('/opt/prometheus/alertmanager.yml') do
    it { should exist }
    its('owner') { should eq 'prometheus' }
  end

  describe systemd_service('alertmanager') do
    it { should be_enabled }
    it { should be_installed }
  end
end
