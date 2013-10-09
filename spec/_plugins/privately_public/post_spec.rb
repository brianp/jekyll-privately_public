require './spec/spec_helper'

describe Jekyll::PrivatelyPublic::Post do
  before do
    clear_dest
    suppress_output
    stub(Jekyll).configuration do
      Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                             'destination' => dest_dir})
    end

    @site = Site.new(Jekyll.configuration)
    @site.process

    @entry = @site.privpub_posts.first
  end

  after do
    unsuppress_output
  end

  subject { Jekyll::PrivatelyPublic::Post }

  it 'creates the same url multiple times' do
    post = subject.new(@site, source_dir, '', @entry.name)
    post.url.must_equal private_post_url
  end

  it 'outputs /special/ as the privpub_path' do
    @site.config[:privpub_path] = 'special'
    @site.process
    @entry.url.must_equal '/special/0426e1/privpub-post'
  end

  it 'strips leading and trailing slashes from the path' do
    @site.config[:privpub_path] = '////special////'
    @site.process
    @entry.url.must_equal '/special/0426e1/privpub-post'
  end

  it 'allows multi level paths' do
    @site.config[:privpub_path] = '/my/special/dir/'
    @site.process
    @entry.url.must_equal '/my/special/dir/0426e1/privpub-post'
  end
end
