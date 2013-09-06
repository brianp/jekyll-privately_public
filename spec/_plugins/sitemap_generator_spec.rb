require './spec/spec_helper'

describe Jekyll::PrivatelyPublic do
  before do
    clear_dest
#    suppress_output
    stub(Jekyll).configuration do
      Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                             'destination' => dest_dir})
    end

    @site = Site.new(Jekyll.configuration)
    @site.process

    @file = dest_dir + '/sitemap.xml'
  end

  after do
#    unsuppress_output
  end

  it 'creates a sitemap file with no private urls' do
    File.readlines(@file).each do |line|
      line.include?('/private/').must_equal false
    end
  end

  it 'creates a sitemap file with published posts' do
    File.readlines(@file).each do |line|
      line.include?('published-post').must_equal true
    end
  end

end
