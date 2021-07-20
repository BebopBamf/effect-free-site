+++
title = "The DevOps Primer Workshop"
date = 2021-07-20
draft = false

[taxonomies]
categories = ["Projects"]
tags = ["projects", "System Administration", "DevOps", "enterprise web development"]
+++

At university I had a course based on unix system administration called web 
systems. At the same time I was reading a book called "The Unix and Linux System
Administrators Handbook, 5th Edition" which was recommended to me. I contacted
our lead at the google developers club about possibly creating a workshop based
on devops and system administration. Thus the sysadmin_workshop was built. After
writing part of it, realising it was a terrible idea and impractical for use for
anyone, we decided to scrap it, and replaced it with a primer workshop. The
intention is to show how to deploy applications for hobby use using dev ops
principles in order to prepare for when we demonstrate production uses such as
using terraform for continuous delivery.

<!-- more -->

# Description

So originally as described previously the workshop was called the sysadmin
workshop, showing a bit of everything. Including unix file structure,
permissions, selinux and more. We did not completely scrap the project. We just
copied and pasted the jenkins setup and used it to deploy an actual app instead
of Jenkins. The point was to show how you would deploy a heroku like setup but
completely from scratch using nginx.

The actual workshop contains information about everything you would need to have
a strong foundation in devops and system administration. Still retaining
information on selinux and linux permissions. It uses github actions to build
and deploy the application. The project is hosted on digital ocean, and uses
centos 7 droplets.

The project being deployed is actually part of a different work in progress
workshop, where we are thinking about presenting functional programming as a
good alternative to using object oriented principles to develop web
applications. Functional programming is very versatile so we could present the
same principles over multiple stacks. The easiest to deploy is rust with a
completely static binary (no dependancies), and a elm frontend (also no
dependancies). So that is what we chose to deploy.

The original sysadmin workshop used a slightly different stack of react
javascript and a rust api.

## Sources

<https://github.com/Macquarie-University-DSC/devops_primer_workshop>

<https://github.com/Macquarie-University-DSC/sysadmin_workshop>
