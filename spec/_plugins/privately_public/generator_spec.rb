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
  end

  after do
    unsuppress_output
  end

#  describe Jekyll::PrivatelyPublic::Generator do
#    subject { Jekyll::PrivatelyPublic::Generator }

#    before do
#      @site = Site.new(Jekyll.configuration)
#    end
#
#    it 'adds one privpub post to the pages array' do
#      gen = subject.new
#      gen.read_posts(@site)
#      @site.privpub_posts.count.must_equal 1
#    end
#
#    it 'ensures only one page will be created after multiple processes' do
#      2.times { @site.process }
#      @site.privpub_posts.count.must_equal 1
#    end
#
#    it 'checks to see the file was created' do
#      File.exists?(dest_dir(private_post_url)).must_equal true
#    end
#
#    it 'verifies the output contains a single post' do
#      gen = subject.new
#      out = capture_stdout do
#        gen.generate(@site)
#      end
#
#      expectation = "   PrivatelyPublic: Generated privately public links:\n                    - /private/0426e1/privpub-post\n"
#      out.must_equal expectation
#    end
#
#    it 'checks for a privately public page' do
#      File.exists?('spec/public/private/eda4eb/contact').must_equal true
#    end
#  end
end
