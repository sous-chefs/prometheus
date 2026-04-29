# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe PrometheusCookbook::Helpers do
  subject(:helper) { Class.new { include PrometheusCookbook::Helpers }.new }

  it 'derives archive names from release URLs' do
    expect(helper.archive_name('prometheus', '2.2.1', 'https://example.test/prometheus-2.2.1.linux-amd64.tar.gz')).to eq('prometheus-2.2.1.linux-amd64')
  end
end
