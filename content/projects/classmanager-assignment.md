+++
title = "The Original Classmanager Assignment"
date = 2021-07-14
draft = false

[taxonomies]
categories = ["Projects"]
tags = ["projects", "backend web development", "frontend web development", "GraphQL", "GoLang", "Typescript", "React"]
+++

This project was my first ever major web development project. Having had
previous experience with django, was vastly unprepared for the scope of this
project. This was a project written in golang, typescript (functional), react,
and graphql. It implemented it's own identity management functionality partly
for simplicity and partly because I didn't know any better. It used react-router
and react. State management was not implemented properly, but overall was a good
start to web development.

<!-- more -->

# Description

The documentation was written using microsoft word documents. I absolutely hate
this in retrospect. This was long before my experience using tools like swagger
and latex. Originally I planned on using Java wanting a break from django, but
being a functional programmer, and getting my feat wet I decided on GoLang (can
confidently say after the assignment I absolutely hate golang). At the time my
peers in my software class were obsessed with writing the most technical code
possible, using massive pyramids of for loops and highly imperitive styles. This
lead to a code style guideline I imposed on myself. Files under absolutely no
circumstances were allowed to exceed 1000 lines of code. I wasn't allowed to go
more then 2 deep in a if or for loop structure.

Check out the `./pkg` folder. Most of the code barely hits the 100 line, and the
biggest files barely exceed ~200 lines.

```go
// ./pkgs/Auth/tokens.go
package Auth

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/emendoza/classmanager/pkg/Env"
	"github.com/emendoza/classmanager/pkg/Models"
)

// verify if token is valid for given user role
func VerifyToken(tokenString string, role Models.Role) bool {
	// Verify if token exists
	if tokenString == "" {
		fmt.Println("Token not found")
		return false
	}

	// parse json web token and validate using secret key
	token, err := jwt.Parse(tokenString, func(token *jwt.Token)(interface{}, error){
		return Env.GetSecretKey(), nil
	})

	// check if token is valid
	if err != nil || !token.Valid {
		fmt.Println("could not verify token")
		return false
	}

	// map json web token claims to claims variable
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		fmt.Println("could not map claims")
		return false
	}

	// verify user
	if claims["role"] == string(role) {
		return true
	}
	fmt.Println("user not validated")
	return false
}
```

On the other hand the react project was a mess. I rewrote the client side about
4 times. I think I might have attempted first to use purescript. Deciding using
typescript, failed to setup webpack with typescript, set it up using javascript
then creating something that worked, having it not work at all. In the end I
used create-react-app react-hooks and typescript.

Something I completely forgot about till now is that I used material-ui. While
material-ui is a great framework. From my very, very biased perspective, all
material design is completely yuck. Making something that does not look pretty
look pretty is a challenge. That isn't to say bootstrap looks pretty, but
bootstrap is for bootstrapping projects and restyling them later, with
responsive workflows. Material Design is an ugly opinionated design system.

```typescript
import React from 'react';
import jwt from 'jsonwebtoken';
import { Redirect, withRouter, RouteComponentProps } from 'react-router-dom';
import { makeStyles, Theme } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import Button from "@material-ui/core/Button";
import AppBar from "@material-ui/core/AppBar";


import Timetable from './timetable';
import ListClasses from './classes-list';

const useStyles = makeStyles((theme: Theme) => ({
    root: {
        display: 'flex',
    },
    menuButton: {
        marginRight: theme.spacing(2)
    },
    title: {
        flexGrow: 1
    }
}));

interface TeacherDashProps extends RouteComponentProps {}

const TeacherDashboard = (props: TeacherDashProps) => {
    const authToken = localStorage.getItem('auth-token');
    const classes = useStyles();

    const _teacherId = (): number => {
        if (authToken) {
            const decodedToken = jwt.decode(authToken) as any;
            console.log(decodedToken);
            const id: number = decodedToken['id'] as number
            return id
        }
        return 0
    }

    const handleLogout = () => {
        localStorage.removeItem('auth-token');
        props.history.push('/');
    };

    if (!authToken) return <Redirect to="/login" />;

    return (
        <div className="root">
            <CssBaseline />
            <AppBar position="static">
                <Toolbar>
                    <Typography variant="h6" className={classes.title}>
                        Teacher Dashboard
                    </Typography>
                    <Button color="inherit" onClick={handleLogout}>Logout</Button>
                </Toolbar>
            </AppBar>
            <Timetable teacherId={_teacherId()} />
            <ListClasses teacherId={_teacherId()} />
        </div>
    )
};
export default withRouter(TeacherDashboard);
```

## Project Sources:

<https://github.com/emendozaspx/classmanager>

<https://github.com/emendozaspx/classmanager_frontend>
