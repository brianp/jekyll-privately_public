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

    @private_url = '/private/0426e1/privpub-post'
  end

  after do
    unsuppress_output
  end

  it 'generates one folder in the private dir' do
    Dir.glob("#{dest_dir('private')}/*").count.must_equal 1
  end

  it 'generates a consistant url' do
    folder = Dir.glob("#{dest_dir('private')}/*").first
    clear_dest
    @site.process
    new_folder = Dir.glob("#{dest_dir('private')}/*").first
    folder.must_equal new_folder
  end

  describe Jekyll::PrivatelyPublic::Post do
    subject { Jekyll::PrivatelyPublic::Post }

    it 'creates the same url multiple times' do
      entry = @site.pages.first.name
      post = subject.new(@site, source_dir, '', entry)

      post.permalink.must_equal @private_url
    end
  end

  describe Jekyll::PrivatelyPublic::Generator do
    subject { Jekyll::PrivatelyPublic::Generator }

    before do
      @site = Site.new(Jekyll.configuration)
    end

    it 'adds one privpub post to the pages array' do
      gen = subject.new
      gen.read_posts(@site)
      @site.pages.count.must_equal 1
    end

    it 'ensures only one page will be created after multiple processes' do
      2.times { @site.process }
      @site.pages.count.must_equal 1
    end

    it 'verifies the output contains a single post' do
      gen = subject.new
      out = capture_stdout do
        gen.generate(@site)
      end

      expectation = "Generated privately public links:\n- /private/0426e1/privpub-post\n"
      out.must_equal expectation
    end
  end
end
