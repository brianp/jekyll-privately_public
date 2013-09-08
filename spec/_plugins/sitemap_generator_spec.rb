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
    results = []
    File.readlines(@file).each do |line|
      results << line.include?('/private/')
    end

    results.include?(true).must_equal false
  end

  it 'creates a sitemap file with published posts' do
    results = []
    File.readlines(@file).each do |line|
      results << line.include?('published-post')
    end

    results.include?(true).must_equal true
  end

end
