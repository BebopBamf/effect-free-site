+++
title = "Lockdown Code Part 3: Integrating a Database"
date = 2021-07-26
draft = false

[taxonomies]
categories = ["Lockdown Code"]
tags = ["enterprise web development", "backend web development", "frontend web development", "REST APIs", "Functional Programming", "SQL Server", "Database", "meta-programming"]
+++

One of the first Blog Posts I had ever made discussed F#'s terrible database
support as one of the downsides to the language. Around 6 months in it has only
gotten worse. Although if you ignore all the advise and seek out more realistic
solutions to database integration in F# you will find a very elegant functional
solution with a few minor downsides and a lot of major upsides.

<!-- more -->

# Databases in F#

As far as I know there is really three ways to do database integration in F#
applications. Instead of the usual progress update I wanted to do a more
educational post about the upsides, downsides and where to use all three
implementations.

The three methods are in no particular order.

- Write database and models in C# as a dotnet library and import into F#.

- Use an F# Type Provider.

- Use a Micro-ORM and integrate into F# (What I chose to do).

Using an F# Type provider is the most F# solution, offering the stability and
benefits of programming in F#, written natively for F#. Although sometimes not
everything is as good as it sounds in practice.

## Writing your Models in C#

There are multiple pros and cons for this solution such as.

Pros.

- Better support for dotnet ORMs.

- Easier to directly map SQL into objects or structs.

- Easier to integrate with multi-language web applications.

Cons.

- If using C# in F#, you have to convert exceptions to Results for every time
  you create error prone code.

- Building on the previous, written in C# so missing the safety guarentees of
  using a functional programming language. Writing your models in C# kind of
  breaks the railway oriented programming principles. This makes writing web
  applications in F# sort of redundant, and would be better off just writing
  everything in C#.

- Missing compile time type checking of sql queries.

I would recommend using this approach for web applications that use a mix of F#
and C# code. Using this approach in a code base that is entire F# is redundant.

As functional programmers we want our database to return results so that we can
handle errors in a continuous railway oriented fashion. If we have database
exception handling in C#, we end up using a non-functional approach to handling
database errors, and as web developers, issues between parsing JSON and
interactions in the database are the primary areas where Railway Oriented
Programming comes in handy. So getting rid of railway oriented programming in
the database sorts of makes it redundant to use F# at all.

## Using F# Type Providers

I especially wanted to write about this approach because I have very strong
criticisms of it. I think it makes it hard for newcomers in the language, and it
isn't F# as a languages fault, it is just the lack of knowledge.

As mentioned by multiple people that any book, or forum or website that you go
on will probably say that Type Providers are the best and only way to create
database interactions in F# applications. This is not the case.

To understand why, let us go into the pros and cons.

Pros.

- Compile time type checking of SQL Queries.

- F# integrated language support.

Cons.

- Documentation not that great (applies to most things though)

- Only supports .NET Core 2.1 or less, or the .NET Framework.

- Required to have connection string available at compile time.

- Needs some sort of database connection at compile time.

- Terrible for CI and CD.

- I personally don't like the error handling.

I think the biggest thing here is that since it does not properly support .NET
Core on any of it's providers I had a look at, it is redundant for web
development.

There are many implementations of SQL Type Providers, which generates F# types
from SQL Queries and allows you to have compile time type checking and
Intellisense on your SQL Queries. The two big ones are SQLProvider, and
FSharp.Data.SqlClient.

Please have a look at both, because while I could be wrong I find that the way
they handle errors is unintuitive especially to functional programmers who
should be the target audience of F# web developers. Haskell returns an IOMonad,
Rust returns a Result for it's database interactions, both have clear ways of
dealing with Errors and Exceptions in it's database logic, so where are the
errors and exception handling in the type providers?

Looking at the code, because the code is type checked at compile time, the F#
developers see no need for returning results or handling runtime exceptions. In
a web application, first of all, the database the program is built with may not
be the same as the database it uses in production. Also it does not factor into
real world factors such as power loss, unexpected network shortages. I might not
be an expert but error handling in F# databases still seems pretty shit.

Every single book I have read claims that F# type providers are the most
powerful feature that is unique to F# and sets it apart. This aggrevates me, to
me F# power comes from its highly functional design. The ability to safely
transform errors in a enterprise environment like .NET is extremely powerful to
me, and the only other language that I can see similar to it in this aspect is
Clojure or Scala. Type Providers on the other hand are not that powerful and not
that unique to F#. While F# is probably the language that has 'Type Providers',
Type Providers are what every other programming language calls meta-programming.

Meta-programming is when a programming language generates code at compile time,
it is not new and it isn't even a functional programming concept. It exists in
C and C++, and it is used heavily in Rust. For comparison the main database
interaction in rust would be sqlx which also includes meta-programming macros
for compile time verification of sql queries. The thing is though, is it is
neither the recommend approach for developing databases, or does it promise
safety. It is just a approach so that you have a better IDE experience when
making SQL queries for compile time mapping to structs. It is super easy to use
a non-compile time query, and it makes it easy for using within CI/CD pipelines.

I find it almost offensive, simply because while 99% of F# devs started off with
programming in C# first, switching codes to F# they were probably blown away
with the thought of meta-programming. I also started off as a C# developer but
"in highschool", late highschool I uninstalled C# because my school computer
didn't have enough space for a 30 Gigabyte text editor, and switched to C++. In
University I used Rust, then Haskell so for my background in programming
meta-programming has always existed and by no means is it mind blowing.

If you want to see meta-programming SQL done well, I would check out my Rust
projects or any Rust SQLx example.

```rust
// model.rs -> tasks_api_rs
pub async fn create(task: &NewTask, pool: &PgPool) -> Result<Task> {
    let result = sqlx::query_as!(
        Task,
        "
        INSERT INTO tasks (name, description, due_date, is_complete)
            VALUES ($1, $2, $3, $4)
            RETURNING id, name, description, due_date, is_complete
        ",
        &task.name,
        &task.description,
        task.due_date,
        task.is_complete
    )
    .fetch_one(pool)
    .await?;

    Ok(result)
}

// handlers.rs -> tasks_api_rs
#[post("/task")]
pub async fn create_task(
    new_task: web::Json<NewTask>,
    db_pool: web::Data<PgPool>,
) -> Result<HttpResponse, ClientError> {
    let result = Task::create(&new_task.into_inner(), db_pool.get_ref())
        .await
        .map_err(|e| {
            info!("database error: {}", e);
            match e {
                Error::Database(_) => ClientError::new(
                    ErrorCodes::InvalidInput,
                    "Database said invalid input.".to_string(),
                ),
                _ => ClientError::new(
                    ErrorCodes::InternalServerError,
                    "Something went wrong with the database.".to_string(),
                ),
            }
        })?;

    Ok(HttpResponse::Created().json(result))
}
```

For a language that is less functional then F# it sure does have a more
functional library for database interaction...

Anyways that is not to say there is no use and no place for F# type providers.
As soon as I see dotnet core support accross all versions I reckon it might be
more popular for web development. The main recommendation for type providers
F# books recommend is SQLClient but it hasn't been updated in 8 months, and most
type providers use the System.Data.SqlClient library which doesn't support .NET
Core. As soon as this is fixed it could be a option although probably not my
favourite for integration with ASP.NET Core services. On the other hand, I think
type providers would be a great option for Fat WinForms or WPF .NET Framework
applications using something like elmish-wpf.

## Using a Micro ORM for database interactions

Boy I had to go digging to find these libraries and resources to do this. I
found this solution in the Saturn Source Code and an article.

<https://nozzlegear.com/blog/using-dapper-with-fsharp>

I ended up thinking the Saturn implementation was so good that I copied it
shamelessly. That being said, Saturn and SAFE Stack are two really good
frameworks for F# that would have made everything a lot quicker to develop. I
didn't use them because I like writing everything from scratch and using as
little libraries as possible (silly me).

[Saturn Project](https://saturnframework.org/)

[SAFE Stack](https://safe-stack.github.io/)

The pros and cons are simple.

Pros.

- Works with .NET Core

- Easy to create functional interfaces for that sweet sweet railway oriented
  programming.

Cons.

- No compile time type checking.

- It means using C# libraries in F# (You'll have to do this anyway at some point
  if building ASP.NET Core web applications).

Before I criticised writing models in C# because it's C# interface breaks
railway oriented principles, but somehow this doesn't? Well it is because for
this purpose you only need to convert the C# query functions to F# constructs
rather then every individual model.

It essentially works by using a Dictionary object to model abstract classes.
This solution isn't perfect and high performance programmers will cry because it
means using Dynamic Polymorphism which Rust developers try there very hardest to
avoid.

On the other hand, if we take a look at the SQLx Rust Library without the
meta-programming, then it boils down to connecting a driver, using the
fetch_one, fetch_all and execute functions. They return results and make railway
oriented programming easy breezy.

I did not copy the saturn code because it was the best solution I found, I
copied it because the interface was almost exactly the same as what I would have
used in Rust.

```fs
// Copyrighted code from Saturn (MIT LICENSE)
// https://github.com/SaturnFramework/Saturn

namespace ClassroomManager.Models

module Database =
    
    open Microsoft.Data.SqlClient
    open Dapper

    let inline (=>) a b = a, box b

    [<Literal>]
    let ConnString =
        "Server=EUAN-WIN-PC;Database=ClassroomManagerDB; Integrated Security=True"

    let executeAsync sql param =
        async {
            use conn = new SqlConnection(ConnString)

            try
                do! 
                    conn.ExecuteAsync(sql, param) 
                        |> Async.AwaitTask
                        |> Async.Ignore
                
                return Ok ()
            
            with
            | ex -> return Error ex
        
        }

    let querySingleAsync sql param =
        async {
            use conn = new SqlConnection(ConnString)

            try
                let! result =
                    match param with
                    | Some p -> conn.QuerySingleOrDefaultAsync<'T>(sql, p) |> Async.AwaitTask
                    | None -> conn.QuerySingleOrDefaultAsync<'T>(sql) |> Async.AwaitTask
                    
                return
                    if isNull (box result) then Ok None
                    else Ok (Some result)

            with
            | ex -> return Error ex
        }

    let queryAsync sql param =
        async {
            use conn = new SqlConnection(ConnString)

            try
                let result =
                    match param with
                    | Some p -> conn.QueryAsync<'T>(sql, p)
                    | None -> conn.QueryAsync<'T>(sql)
                    |> Async.AwaitTask
 
                return Ok result
            
            with
            | ex -> return Error ex
        
        }
```

This came down to roughly 68 lines of code, and a near identical interface to
what rust has. Even though I do not have compile time intellisence
meta-programming magic, I would give all that up just for this super nice Rust
like interface for SQL programming.

My main criticism for when I first tried F# was that the database support
sucked, I can confidently say if I knew this existed back then I would have
eaten my words. Now my criticism has been redirected to the lack of resources
and education regarding database interface best practices.

This I would recommend using for any instance you would need database
interactions in F# if you are willing to give up compile time database support.

## What comes next?

I think now we need to create our first routes. Look into actual railway
oriented programming and the power of functional programming. The first step in
doing this is to set up Auth0 and security.

Thanks.

