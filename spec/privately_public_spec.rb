require './spec/spec_helper'

describe Jekyll::Post do
  before do
    stub(Jekyll).configuration do
      Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                             'destination' => dest_dir})
    end

    @site = Site.new(Jekyll.configuration)
    @site.process
    @index = File.read(dest_dir('index.html'))
  end

  it 'will fail' do
    true.must_be false
  end
end
