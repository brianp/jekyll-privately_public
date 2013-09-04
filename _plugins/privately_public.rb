
require 'digest'

# encoding: utf-8
#
# Jekyll publisher for privateley public posts.
#
# Version: 0.1.0
#
# Copyright (c) 2013 Brian Pearce, http://www.alwayscoding.ca
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates privately public pages. Pages secured only by url
# obscurity. Links are published to the console during generation or via rake
# task. Links can be given to friends for previewing.

module Jekyll

  module PrivatelyPublic

    class Post < Jekyll::Post
      def permalink
        "/private/#{digest}/#{CGI.escape(slug)}"
      end

      def html?
        true
      end

      def uses_relative_permalinks
        permalink && @dir != "" && site.config['relative_permalinks']
      end

      protected

      def digest
        CGI.escape(Digest::SHA1.hexdigest(slug)[0...6])
      end
    end

    class Generator < Jekyll::Generator
      safe true
      priority :normal

      def initialize(config = {})
        @privpub_posts = []
      end

      def read_posts(site, dir = '')
        entries = get_entries(site, dir, '_posts')

        # first pass processes, but does not yet render post content
        entries.each do |f|
          if Post.valid?(f)
            post = Post.new(site, site.source, '', f)

            if post.data.has_key?('privpub') && post.data['privpub'] == true
              @privpub_posts << post
              site.pages << post
            end
          end
        end
      end

      def get_entries(site, dir, subfolder)
        base = File.join(site.source, dir, subfolder)
        return [] unless File.exists?(base)
        entries = Dir.chdir(base) { site.filter_entries(Dir['**/*']) }
        entries.delete_if { |e| File.directory?(File.join(base, e)) }
      end

      def display_results
        if !@privpub_posts.empty?
          puts 'Generated privately public links:'

          @privpub_posts.each do |p|
            puts "- #{p.permalink}"
          end
        end
      end

      def generate(site)
        read_posts(site)
        display_results
      end
    end

  end
end

if defined?(SitemapGenerator)
  class Jekyll::SitemapGenerator
    def excluded?(name)
      !EXCLUDED_FILES.select {|e| e.match(name)}.nil?
    end
  end
end
