require 'digest'
require 'pathname'

# encoding: utf-8
#
# Jekyll publisher for privateley public posts.
#
# Version: 0.3.0
#
# Author: Brian Pearce
# Site: http://www.alwayscoding.ca
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates privately public pages. Pages secured only by url
# obscurity. Links are published to the console during generation or via rake
# task. Links can be given to friends for previewing.

module Jekyll
  module PrivatelyPublic
    module Permalinks
      protected

      def privpub?
        data['privpub'] == true
      end

      def privpub_path
        !site.config[:privpub_path].nil? ? Pathname.new("/#{site.config[:privpub_path]}").cleanpath : '/private'
      end

      def digest
        CGI.escape(Digest::SHA1.hexdigest(uri_name)[0...6])
      end
    end

    class Page < Jekyll::Page
      include Permalinks

      def url
        privpub? ? "#{privpub_path}/#{digest}/#{CGI.escape(uri_name)}" : super
      end

      private

      def uri_name
        @dir
      end
    end

    class Post < Jekyll::Post
      include PrivatelyPublic::Permalinks

      def url
        privpub? ? "#{privpub_path}/#{digest}/#{CGI.escape(uri_name)}" : super
      end

      private

      def uri_name
        slug
      end
    end

    class PageGenerator < Jekyll::Generator
      safe true
      priority :normal

      def read_posts(site)
        site.posts.each do |post|
          #remove from list
        end
      end

      def generate(site)
        read_posts(site)
      end
    end

    class PostGenerator < Jekyll::Generator
      safe true
      priority :normal

      def read_posts(site, dir = '')
        entries = site.get_entries(dir, '_posts')

        # first pass processes, but does not yet render post content
        entries.each do |f|
          if Post.valid?(f)
            post = Post.new(site, site.source, '', f)

            if post.data.has_key?('privpub') && post.data['privpub'] == true
              site.privpub_posts << post
            end
          end
        end
      end

      def display_results(site)
        privpub_path = site.config[:privpub_path]
        paths = Dir.glob("#{dest_dir(privpub_path)}/*")

        unless paths.empty?
          puts Jekyll.logger.message('PrivatelyPublic:', 'Generated privately public links:')

          paths.each do |p|
            puts Jekyll.logger.message('',  "- #{p.permalink}")
          end
        end
      end

      def generate(site)
        read_posts(site)
      end
    end
  end

  class Site
    attr_accessor :privpub_posts

    alias_method :previous_reset, :reset
    def reset
      self.privpub_posts = []
      previous_reset
    end

    alias_method :previous_render, :render
    def render
      payload = site_payload
      self.privpub_posts.each do |post|
        post.render(self.layouts, payload)
      end
      previous_render
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end

    alias_method :previous_write, :write
    def write
      self.privpub_posts.each do |post|
        post.write(self.dest)
      end
      previous_write
    end
  end

  class Page
    include PrivatelyPublic::Permalinks

    alias_method :previous_url, :url
    def url
      privpub? ? "#{privpub_path}/#{digest}/#{uri_name}" : previous_url
    end

    private

    def uri_name
      @dir
    end
  end
end
