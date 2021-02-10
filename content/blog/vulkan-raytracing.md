+++
title = "Raytracing using Vulkan"
date = 2021-02-08

[taxonomies]
categories = ["Development"]
tags = ["Rust", "Graphics", "Vulkan"]
+++

Bit of a little update on me and raytracing

<!-- more -->

# A Raytracing Engine in Vulkan
Mid last year, for no reason at all, I tried adapting the Ray Tracing in One Weekend book to Rust, and created my 'first' raytracing engine.
This was one of the most fun projects I have ever taken up and doing research and learning was an essential part of it. It taught me a lot
about the inner workings of concurrent programming, and also taught me a lot about graphics and maths. Then early this year I discovered a new
library. This library was called Vulkano, it is a simple rust binding to vulkan, but anyone who has ever tried to use vulkan before would also
know about the annoyingly large amount of boilerplate involved in writing vulkan code. This library abstracted alot of that boiler plate away.
One of the biggest features of the library I was most excited about was how easy it was to output to an image rather then a window so I wouldn't 
have to deal with windows or rendering in real time. Of course this could probably be done in cpp, but I felt like it would be a lot more work, ontop
of trying to figure out compute shaders.

## Struggles of not really being a graphics programmer
One major issue I found was that I had no clue what anything did and despite extensive articles and guides, I still struggled to understand what everything
did. Playing around with the shader I wrote to produce the first image in the book resulted in my computer crashing many, many times.

Currently this project is not released on gitlab, but that shall be coming soon when I get time to work on it properly.
