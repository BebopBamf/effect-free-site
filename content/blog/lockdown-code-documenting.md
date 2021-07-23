+++
title = "Lockdown Code Part 2: Documenting a classroom manager"
date = 2021-07-23
draft = false

[taxonomies]
categories = ["Lockdown Code"]
tags = ["enterprise web development", "backend web development", "frontend web development", "REST APIs", "Functional Programming", "Documenting", "Agile", "Dev Ops"]
+++

About a week ago we discussed planning a REST API and web application. This week
we are going to go through creating documentation and iterating over planning.
We will also set up the initial boiler plate code for our projects excluding
database stuff, and authentication which will be soon.

<!-- more -->

# Writing documentation for our classroom manager

So before I get into how I created an API Spec, I would like to reiterate the
scope of the project. I discussed before how it seemed quite easy on the surface
but digging below the surface it was insanely complicated.

Our api is missing a lot of features. What happens when a teacher wants to
change his timetable for a single day only instead of make permanent changes
(e.g. change his class location in certain circumstances)? I considered that a
non essential feature for now and something that could be added later on. On the
other hand I reworked the database, because I forgot certain things like a class
would have multiple locations and times instead of one fixed timeslot. Despite
the slight modifications and leaving out features I ended up creating 63 routes
and a specification that was ~2100 lines of code.

I also want to create a distinction between documenting and planning. Planning
is the process of synthesizing ideas into a clear plan with goals in mind. When
you plan you try and write down your ideas into something that is concrete, and
expand those ideas to account for possible errors and flaws. The point of this
is to make the development as easy as possible. Documenting on the other hand is
creating a specification for how your application/product operates. You want it
to be detailed, very specific and very clear on what the application does or is
intending to do. While your plan is created then thrown out, documentation
evolves as your application evolves. There is documentation made for end users
and documentation for developers which we are creating. This documentation tells
us when we develop our server what we need to implement, and tells us when we
create our client side application how to interact with the server.

We incorporated elements of planning into our documentation writing by using it
as a tool to flesh out our initial ideas. On the other end it is just as common
to have tools that autogenerate documentation based on our actual application
code. This is especially common with ASP.NET and swagger.

## Creating boilerplate code

I like to integrate my planning and code as part of my web application.
Sometimes coding is about trying things out and figuring out the easiest way to
do things. Originally since while the specification was for the backend I wanted
to embed it in the front end to declutter the backend. In the end I couldn't get
it to work so I just ended up using redoc-cli to autogenerate a dependancy free
html file and served that with F#.

### Setting up react/webpack/typescript/eslint

Every time I see react/webpack/typescript/eslint I want to cry. Half the work is
coding and the other half is just getting it to work at all. Originally I
planned on using parcel, but I had issues with parcelv1 typescript, and v2 is
still in beta so I switched to the tried and true webpack. Webpack never works
for me and parcel always seems to work, so it was a surprise that webpack worked
right off the bat.

For the backend it will be react-bootstrap, react-router, react-redux,
typescript and possibly more.

The dependances of my project look like this.

`package.json`

```json
{
  "name": "classroom-manager-site",
  "version": "1.0.0",
  "description": "A frontend for a classroom manager",
  "repository": "https://gitlab.com/BebopBamf/classroom-manager-site",
  "author": "Euan Mendoza <bebopbamf@effectfree.dev>",
  "license": "GPL-3.0",
  "private": false,
  "scripts": {
    "start": "webpack serve --mode development --open",
    "build": "webpack --mode production"
  },
  "devDependencies": {
    "@types/react-dom": "17.0.9",
    "@types/react-router-dom": "5.1.8",
    "@typescript-eslint/eslint-plugin": "4.28.3",
    "@typescript-eslint/parser": "4.28.3",
    "css-loader": "5.2.7",
    "eslint": "7.30.0",
    "eslint-config-airbnb-typescript": "12.3.1",
    "eslint-plugin-import": "2.23.4",
    "eslint-plugin-jsx-a11y": "6.4.1",
    "eslint-plugin-react": "7.24.0",
    "eslint-plugin-react-hooks": "4.2.0",
    "eslint-webpack-plugin": "2.5.4",
    "sass": "1.32.13",
    "sass-loader": "12.1.0",
    "style-loader": "3.1.0",
    "ts-loader": "9.2.3",
    "typescript": "4.3.5",
    "webpack": "5.44.0",
    "webpack-cli": "4.7.2",
    "webpack-dev-server": "3.11.2"
  },
  "dependencies": {
    "bootstrap": "4.6.0",
    "react": "17.0.2",
    "react-bootstrap": "1.6.1",
    "react-dom": "17.0.2",
    "react-redux": "7.2.4",
    "react-router-bootstrap": "0.25.0",
    "react-router-dom": "5.2.0"
  }
}
```

For webpack I want type checking and I probably will change this later on but I
have it set to use tsc and the typescript compiler. This is known to have issues
since while provides type checking is apparently insanely slow compared to
babel transpilation.

`webpack.config.js`

```javascript
const path = require('path');
const ESLintPlugin = require('eslint-webpack-plugin');

module.exports = {
    entry: './src/index.tsx',
    devtool: 'inline-source-map',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
            {
                test: /\.s?[ac]ss$/i,
                use: [
                    'style-loader',
                    {
                        loader: 'css-loader',
                        options: {
                            sourceMap: true,
                        },
                    },
                    {
                        loader: 'sass-loader',
                        options: {
                            sourceMap: true,
                        }
                    }
                ]
            }
        ],
    },
    plugins: [
        new ESLintPlugin({
            extensions: ['js', 'jsx', 'ts', 'tsx']
        }),
    ],
    resolve: {
        extensions: ['.tsx', '.ts', '.js', '.jsx', '.css', '.scss'],
    },
    devServer: {
        contentBase: path.resolve(__dirname, 'dist'),
        compress: true,
        port: 1234,
    },
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist'),
    }
};
```

I use a strict set of typescript rules since what is the point of typescript if
you are just gonna use it like you would javascript.

`tsconfig.json`

```json
{
    "compilerOptions": {
        "target": "es5",
        "outDir": "./dist/",
        "module": "esnext",
        "moduleResolution": "node",
        "esModuleInterop": true,
        "allowSyntheticDefaultImports": true,
        "sourceMap": true,
        "strict": true,
        "noImplicitAny": true,
        "strictNullChecks": true,
        "noImplicitThis": true,
        "noImplicitReturns": true,
        "jsx": "react",
        "allowJs": true
    },
    "include": [
        "src/**/*"
    ],
    "exclude": [
        "node_modules"
    ]
}
```

My eslint is pretty much just the airbnb style guide with the addition of
turning off import extensions, and changing the indenting to 4, which I feel
looks nicer in javascript.

`.eslintrc.json`

```json
{
    "env": {
        "browser": true,
        "es2021": true
    },
    "extends": [
        "plugin:react/recommended",
        "plugin:react-hooks/recommended",
        "airbnb-typescript"
    ],
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "ecmaFeatures": {
            "jsx": true
        },
        "ecmaVersion": 12,
        "project": "./tsconfig.json",
        "sourceType": "module"
    },
    "plugins": [
        "react",
        "react-hooks",
        "@typescript-eslint"
    ],
    "settings": {
        "react": {
            "version": "detect"
        }
    },
    "rules": {
        "no-use-before-define": "off",
        "react/jsx-filename-extension": [
            1,
            {
                "extensions": [
                    ".js",
                    ".jsx",
                    ".ts",
                    ".tsx"
                ]
            }
        ],
        "@typescript-eslint/indent": [
            2,
            4
        ],
        "react/jsx-indent": [
            2,
            4
        ],
        "import/extensions": 0
    }
}
```

In terms of what our actual code looks like, I set up a really basic routing
thing.

I structured my web app similar to how you would structure web applications in
elm. Having a main or index file, then having a page module, and submodules for
each page of the web application.

`src/index.tsx`

```tsx
import React from 'react';
import ReactDOM from 'react-dom';
import '../scss/style';

import Page from './page';

ReactDOM.render(
    <Page />,
    document.getElementById('root'),
);
```

`src/page.tsx`

```tsx
import React from 'react';
import {
    BrowserRouter as Router,
    Switch,
    Route,
    Link,
} from 'react-router-dom';
import Navbar from 'react-bootstrap/Navbar';

const NavComponent = () => (
    <Navbar bg="light" expand="lg">
        <Navbar.Brand href="/">Classroom Manager</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
            <Link to="/random-route">Random Route</Link>
        </Navbar.Collapse>
    </Navbar>
);

const Footer = () => (
    <div>
        <Link to="/api/v1/spec">API Link</Link>
    </div>
);

const Page = () => (
    <Router>
        <div>
            <NavComponent />

            <Switch>

                <Route exact path="/">
                    <div>
                        <h1>Home!</h1>
                    </div>
                </Route>

                <Route path="*">
                    <h1>404 Not Found</h1>
                </Route>

            </Switch>

            <Footer />
        </div>
    </Router>
);

export default Page;
```

Lastly our html template is just a basic bootstrap boilerplate html page.

`dist/index.html`

```html
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Classroom Manager</title>
</head>

<body>
  <div id="root"></div>

  <script src="bundle.js"></script>
</body>

</html>
```

### Autogenerating a F# template

So for the backend we are using Giraffe. Giraffe is a light functional wrapper
around ASP.NET. Essentially the code we write is still ASP.NET except giraffe
abstracts it a little so that we can avoid using classes as much as possible.

To do this I used the `dotnet 5` and `aspnet 5` runtimes and sdks for linux.

The steps were.

1. Install giraffe template with `dotnet new -i "giraffe-template::*"

2. Create a new project with `dotnet new giraffe -P -S -V none` which adds paket
   support and a solution to our project. We won't be using view components so
   we set the `-V` flag to none.

## Writing documentation

First thing I did within this project is I made a new folder called `docs`. In
the docs folder I created two folders, `api` and `db`. In the `db` folder I
saved my ER Diagram for my database. I saved it as `schema.png` with following
versions being called `schemavX.png` where `X` is a number.

To set up the documentation was pretty simple.

1. Navigate to the `docs/api` subdirectory.

2. Create a new yarn project with `yarn init -y`.

3. Add redoc as a dev dependancy with `yarn add -D redoc-cli`.

4. Add a script in the package.json
   `"start": "redoc-cli serve ./spec.yml --watch"`. This creates a live server
   for the api spec.

5. Create a new specification with `touch ./spec.yml`

For the development of the spec, I used my previous api specifications I had
made as a base. The code to the actual spec is really long so if you want to
check it out, <https://gitlab.com/BebopBamf/ClassroomManager/-/blob/master/docs/api/spec.yml>.

For the specification, authentication is with `openid connect`. I seperated the
routes into sections based on what the authorization scopes would be. E.g.
`read:behaviourNotes` would be in the `behaviourNote` section or tag. I created
some custom types such as posix timestamps and durations. It was quite a chore.

In the long run I think it was worth it. It would have been more painful to have
begun writing the web application and figuring out I messed up somewhere in the
database schema, and having to rewrite it. The idea being you plan first and
less mistakes afterwards. Of course I don't expect my end result to be free of
bugs and errors, and I don't expect to not change the spec or have problems,
but I expect to have a clear idea of what needs to be done.

## Integrating the specification into our api

The specification is setup in a way that while initially writing it was a chore,
future additions and modifications are super easy. In order to properly
integrate our specification into our API and allow for future modification we
need to slightly modify our build steps for the api documentation.

Initially I used a development server to create the api docs, but now we need to
generate a dependancy free html file and integrate it into the build of our api.

1. Add a yarn script to build the application 
   `"build": "redoc-cli bundle ./spec.yml"` which creates a dependancy free html
   file in our folder.

2. Modify our build scripts to.
   1. Change directory to the api docs folder.

   2. Install yarn dependancies.

   3. Generate our html file with the build command.

   4. Exit back into the root of our application in order to build the fsharp
      project.

e.g. `build.sh`

```sh
#!/bin/sh

cd docs/api

yarn install
yarn build

cd ../..

dotnet tool restore
if [ ! -e "paket.lock" ]
then
    dotnet paket install
else
    dotnet paket restore
fi
dotnet restore
dotnet build --no-restore
dotnet test --no-build
```

Now we have to make the route accessible to our fsharp application.

In my `Program.fs` I made this change to the routes.

```fs
// ---------------------------------
// Web app
// ---------------------------------

let webApp =
    choose [ subRoute
                 "/api/v1"
                 (choose [ GET
                           >=> choose [ route "/hello" >=> handleGetHello
                                        route "/spec" >=> handleSpec ] ])
             setStatusCode 404 >=> text "Not Found" ]

```

and in my `HttpHandlers.fs` I added a handler for serving the spec api file.

```fs
let handleSpec =
    fun (next: HttpFunc) (ctx: HttpContext) ->
        task { return! ctx.WriteHtmlFileAsync @"../../docs/api/redoc-static.html" }
```

## What's Next?

So since we are done documenting and serving our application. What comes next?

I think the next thing will be setting up authentication for our api, and create
the database. Originally was thinking of using postgres because I have literally
never used anything else except mysql. My time with MySQL was terrible and I
hated it, and so I am scared to move away from postgres. Although, I cannot call
myself a F# programmer without having used Microsoft SQL Server, so that is what
I will be using.

Thanks for reading.
