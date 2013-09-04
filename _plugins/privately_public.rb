require 'digest'

# encoding: utf-8
#
# Jekyll publisher for privateley public posts.
#
# Version: 0.0.2
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

  class PrivatelyPublicPost < Post
    #Use a digest so the link isn't re-scrambled on site generation
    def permalink
      "/private/#{Digest::SHA1.hexdigest(slug)[0...6]}/#{CGI.escape(slug)}"
    end
  end

  class PrivatelyPublicPostGenerator < Generator
    safe true

    attr_accessor :privpub_post_count

    def initialize(*args)
      self.privpub_post_count = 0
      super(args)
    end

    def read_posts(site, dir = '')
      base = File.join(site.source, dir, '_posts')
      return unless File.exists?(base)
      entries = Dir.chdir(base) { site.filter_entries(Dir['**/*']) }

      # first pass processes, but does not yet render post content
      entries.each do |f|
        dir = File.join('', f)
        if Post.valid?(f)
          post = PrivatelyPublicPost.new(site, site.source, '', f)

          if post.data.has_key?('privpub') && post.data['privpub'] == true
            Jekyll.logger.message('Privpub', 'Generated privately public links:')
            Jekyll.logger.message('Privpub',  "  #{post.permalink}")
            self.privpub_post_count = self.privpub_post_count + 1
            site.privpub_posts << post
          end
        end
      end
    end

    def generate(site)
      read_posts(site)
    end
  end

end
