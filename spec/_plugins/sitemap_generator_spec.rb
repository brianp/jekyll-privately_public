require './spec/spec_helper'

describe Jekyll::PrivatelyPublic do
  before do
    clear_dest
    suppress_output
    stub(Jekyll).configuration do
      Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                             'destination' => dest_dir})
    end

    @site = Site.new(Jekyll.configuration)
    @site.process

    @file = dest_dir + '/sitemap.xml'
  end

  after do
    unsuppress_output
  end

  it 'creates a sitemap file with no private urls' do
    begin
      file = File.open(@file, 'r')
      file.read.include?('/private/').must_equal false
    ensure
      file.close
    end
  end

  it 'creates a sitemap file with no private page url' do
    begin
      file = File.open(@file, 'r')
      file.read.include?(private_page_url).must_equal false
    ensure
      file.close
    end
  end

  it 'creates a sitemap file with no private post url' do
    begin
      file = File.open(@file, 'r')
      file.read.include?(private_post_url).must_equal false
    ensure
      file.close
    end
  end

  it 'creates a sitemap file with published posts' do
    begin
      file = File.open(@file, 'r')
      file.read.include?('published-post').must_equal true
    ensure
      file.close
    end
  end

end
