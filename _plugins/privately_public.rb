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

  class PrivatelyPublic

    class << self
      attr_accessor :post_names
    end

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
        setup
      end

      def read_posts(site, dir = '')
        entries = site.get_entries(dir, '_posts')

        # first pass processes, but does not yet render post content
        entries.each do |f|
          if Post.valid?(f)
            post = Post.new(site, site.source, '', f)

            if post.data.has_key?('privpub') && post.data['privpub'] == true
              @privpub_posts << post
              Jekyll::PrivatelyPublic.post_names << post.name
              site.pages << post
            end
          end
        end
      end

      def display_results
        if !@privpub_posts.empty?
          puts Jekyll.logger.message('PrivatelyPublic:', 'Generated privately public links:')

          @privpub_posts.each do |p|
            puts Jekyll.logger.message('',  "- #{p.permalink}")
          end
        end
      end

      def setup
        @privpub_posts = []
        Jekyll::PrivatelyPublic.post_names = []
      end

      def generate(site)
        setup
        read_posts(site)
        display_results
      end
    end

  end
end

# If sitemap generator is present load it first so we can we-rite it's methods
begin; require './_plugins/sitemap_generator'; rescue LoadError; end
if defined?(Jekyll::SitemapGenerator)
  class Jekyll::SitemapGenerator
    def excluded?(name)
      (!EXCLUDED_FILES.include?(name) || !Jekyll::PrivatelyPublic.post_names.include?(name))
    end
  end
end
