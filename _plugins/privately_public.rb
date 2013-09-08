require 'digest'

# encoding: utf-8
#
# Jekyll publisher for privateley public posts.
#
# Version: 0.2.0.octopress
#
# Copyright (c) 2013 Brian Pearce, http://www.alwayscoding.ca
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates privately public pages. Pages secured only by url
# obscurity. Links are published to the console during generation or via rake
# task. Links can be given to friends for previewing.

module Jekyll

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

  class PrivatelyPublic

    class Post < Jekyll::Post
      def permalink
        "/private/#{digest}/#{CGI.escape(slug)}"
      end

      protected

      def digest
        CGI.escape(Digest::SHA1.hexdigest(slug)[0...6])
      end
    end

    class Generator < Jekyll::Generator
      safe true
      priority :normal

      def read_posts(site, dir = '')
        entries = get_entries(site, dir, '_posts')

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
        display_results(site)
      end
    end

  end
end
