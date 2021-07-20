+++
title = "The Raytracing Renderer"
date = 2021-07-20
draft = false

[taxonomies]
categories = ["Projects"]
tags = ["projects", "Rust", "Linear Algebra", "Graphics", "Vulkan"]
+++

This project came from the overly long holiday that is the jump between
Highschool and University. All it really is a Rust implementation of the book
"Raytracing in One Weekend".

<!-- more -->

# Description

Being Rust instead of C++, I put concurrency in the project very early on. That
being said, given a large set of pixels the program still took forever to
generate an image. Me being a university student I dropped work on the project
during the first semester of University. After which I had the idea to
completely rewrite the engine but using vulkan and compute shaders.

The old project.

```rust
use std::sync::{Arc, Mutex};
use std::thread;

use image::{Rgb, RgbImage};
use indicatif::{MultiProgress, ProgressBar, ProgressStyle};
use rand::prelude::*;

use crate::camera::Camera;
use crate::helper_lib::*;
use crate::hitsystem::HitSystem;
use crate::math::*;
use crate::ray::Ray;
use crate::{IMAGE_HEIGHT, IMAGE_WIDTH, MAX_DEPTH, SAMPLES_PER_PIXEL, THREADCOUNT};

pub fn anti_aliasing(
    i: u32,
    j: u32,
    cam: Arc<Camera>,
    world: Arc<HitSystem>,
    rng: &mut ThreadRng,
) -> Color {
    let mut pixel_color = color(0.0, 0.0, 0.0);
    for _ in 0..SAMPLES_PER_PIXEL {
        let u: f64 = (j as f64 + rng.gen::<f64>()) / (IMAGE_WIDTH - 1) as f64;
        let v: f64 = (i as f64 + rng.gen::<f64>()) / (IMAGE_HEIGHT - 1) as f64;
        let r: Ray = cam.get_ray(u, v);
        pixel_color += ray_color(&r, &world, MAX_DEPTH);
    }
    pixel_color
}

pub fn multi_threading(cam: Arc<Camera>, world: Arc<HitSystem>, img: Arc<Mutex<RgbImage>>) {
    let m = MultiProgress::new();
    let sty = ProgressStyle::default_bar()
        .template("[{elapsed_precise}] {bar:40.cyan/blue} {pos:>7}/{len:7} {msg}")
        .progress_chars("##-");

    let scanlines_per_thread = IMAGE_HEIGHT / THREADCOUNT;
    let mut threadpool: Vec<thread::JoinHandle<()>> = Vec::with_capacity(THREADCOUNT as usize);
    for id in 0..THREADCOUNT {
        let pb = m.add(ProgressBar::new(scanlines_per_thread.into()));
        pb.set_style(sty.clone());
        let cam = Arc::clone(&cam);
        let world = Arc::clone(&world);
        let img = Arc::clone(&img);
        let handle = thread::spawn(move || {
            let mut rng = thread_rng();
            for i in (scanlines_per_thread * id)..(scanlines_per_thread * (id + 1)) {
                pb.set_message(&format!("Thread #{}", id + 1));
                for j in 0..IMAGE_WIDTH {
                    let pixel_color =
                        anti_aliasing(i, j, Arc::clone(&cam), Arc::clone(&world), &mut rng);
                    let mut image_buffer = img.lock().unwrap();
                    image_buffer.put_pixel(
                        j,
                        IMAGE_HEIGHT - (i + 1),
                        Rgb(write_color(&pixel_color, SAMPLES_PER_PIXEL as f64)),
                    );
                }
                pb.inc(1);
            }
            pb.finish_with_message("Done");
        });

        threadpool.push(handle);
    }

    m.join_and_clear().unwrap();
    for thread in threadpool {
        thread.join().unwrap();
    }
    img.lock().unwrap().save("image.png").unwrap();
    println!("Done");
}
```

The updated but very incomplete project.

```glsl
#version 450

layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

layout(set = 0, binding = 0, rgba8) uniform writeonly image2D img;

void main() {
    ivec2 pixel_coords = ivec2(gl_GlobalInvocationID.xy);

    float r = pixel_coords.x / 255.0;
    float g = pixel_coords.y / 255.0;
    vec2 norm_coordinates = (gl_GlobalInvocationID.xy + vec2(0.5)) / vec2(imageSize(img));
    vec2 c = (norm_coordinates - vec2(0.5)) * 2.0 - vec2(1.0, 0.0);

    vec2 z = vec2(0.0, 0.0);
    float i;
    for (i = 0.0; i < 1.0; i += 0.005) {
        z = vec2(
            z.x * z.x - z.y * z.y + c.x,
            z.y * z.x + z.x * z.y + c.y
        );

        if (length(z) > 4.0) {
            break;
        }
    }

    vec4 to_write = vec4(r, g, 0.25, 1.0);
    imageStore(img, ivec2(gl_GlobalInvocationID.xy), to_write);
}
```

## Sources

<https://gitlab.com/BebopBamf/vulkan-renderer-rs/-/tree/master>

<https://gitlab.com/BebopBamf/ray-tracing-rs>
