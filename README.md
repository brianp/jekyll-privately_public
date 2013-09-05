# Privately Public

A generator that creates privately public pages. Pages secured by url obscurity.

## Why?
The use case for privately public posts are when you have a page drafted
but aren't ready to publish it yet. You are ready to share it with close
friends to have them proof your horrible grammar though. It publishes
your post with a secret url you can share. Security through obscurity!

## Usage
Copy the `_plugins/privately_public.rb` file into your projects plugin
folder. Now in your posts YAML front-matter add the key `privpub:
true`.

    ---
    layout: post
    title: "My Awesome Post"
    privpub: true
    ---

You will now see output in the console when generating your site and you
can grab the link from there:

    [2013-09-04 21:51:25] regeneration: 1 files changed
    PrivatleyPublic: Generated privately public links:
    - /private/4d58d7/my-awesome-post

You can now copy the relative path to access the privately public page
and share it with friends!
