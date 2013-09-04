require './spec/spec_helper'

describe Jekyll::PrivatelyPublicPost do
  before do
    clear_dest
    stub(Jekyll).configuration do
      Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                             'destination' => dest_dir})
    end

    @site = Site.new(Jekyll.configuration)
    @site.process
  end

  it 'adds 1 post to the privpub_posts collection' do
    @site.privpub_posts.count.must_equal 1
  end

  it 'generated 1 file in the private dir' do
    Dir.glob("#{dest_dir('private')}/*").count.must_equal 1
  end
end
