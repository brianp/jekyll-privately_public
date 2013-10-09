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

  it 'generates two folders in the private dir' do
    Dir.glob("#{dest_dir('private')}/*").count.must_equal 2
  end

  it 'generates a consistant url' do
    folder = Dir.glob("#{dest_dir('private')}/*").first
    clear_dest
    @site.process
    new_folder = Dir.glob("#{dest_dir('private')}/*").first
    folder.must_equal new_folder
  end
end
