+++
title = "What's Next?"
date = 2021-10-03
draft = false

[taxonomies]
categories = ["Next"]
tags = ["What is next!"]
+++

So this blog post is to annouce that the blog is now temporarily defunct and I
will no longer be writing content in the near future to this specific website.

<!-- more -->

# What is Next?

There are a lot of reasons for this website being defunct and none of them are
anything bad or inter personal. A lot of it comes down to what I wanted out of
having a website and what I had.

It may be noticable to some that the blog is actually missing a few icons. I
don't know why and I do not know where they went. That is for one, a reason why
I am discontinuing this blog.

The main reason is because of my growth and my development in the last few
months. When I made this website, I wanted to write some of my programming ideas
and have a platform to share. While this is still the case, writing markdown
files in a pre made template was probably not my preferred choice.

It was around this time when someone showed me both Chakra UI, Sanity Studio and
JamStack. A little while later I started doing more projects moving from
back-end web development to front-end web development and design. Given that
my website has issues such as fonts not loading properly, and icons not showing
up. I thought there was no better time to redesign my website.

## Remaking the website

For the new website originally I was going to use bootstrap, but in the end I
decided not to. It wasn't because bootstrap was bad, just because Chakra I think
works better for my specific needs. I also started migrating to sanity, the
benefits of this was really just time. Having a WYSIWYG editor, and having a
auto correct feature was extremely useful.

I also tried soooo many different libraries for client side development, using
Nuxt, Next, Vue3 cli, Vue2 cli, vite before finally settling on using vite and
react. The reason was simply because Chakra-UI had issues in the vue version
specifically related to responsive styles.

It is also worth mentioning that I did not end up using JAMStack. The I prefer
Vue and NuxtJS, and so with not being able to use the Vue version I tried Next.
I had issues getting routing to work correctly, and was not a massive fan of the
library, deciding to forego JAMStack, for a fully dynamic blog, for my sanity.

Right now I am currently working on the layout for the author components, and
the layout of the home page of the new site.

You can see the site at <https://preview.effectfree.dev>

You can also see the progress of the development at
<https://github.com/BebopBamf/effectfree-react>

## What happened to the Classroom Manager?

Seconds away from scrapping the API or making a database library, I happened to
stumble upon the updated website for FSharp library resources, which included
projects with support for dotnet5 and databases. As such I decided not to scrap
the API, but instead remake the structure and the planning. Now instead of doing
heaps of planning and writing an API spec and all that. I have decided to use
good old Jira, and do the project incrementally. Documentation can be written
as the project is written, instead of at the start, and documentation is
generated from code using swagger and using datagrip.

Another key difference now, is the greater emphasis on writing prototypes,
developing the client-side at the same time as the back-end and also trying out
figma wireframes.

I changed the project to be a monorepo now located at
<https://gitlab.com/BebopBamf/ClassroomManager>

## Hackathon Stuff!

I entered a hackathon with friends. Not much to say other than no sleep, and
you can read more about it at <https://devpost.com/software/musicmate-bay4th>

I would like to continue working on this project and I think it would be cool to
add things like redux, and have real time chat with web sockets.

That's it from me, signing off.

