+++
title = "The Matrix Template"
date = 2021-07-20
draft = false

[taxonomies]
categories = ["Projects"]
tags = ["projects", "C++", "Template Programming", "Linear Algebra"]
+++

During my time at Macquarie, in a unit called 'Fundamentals of Computer Science'
we had a 0 mark just for fun assignment. The assignment was to implement a
matrix library and was to demonstrate our understanding of arrays. The problem
was that the template was written in Java. Having a foundation in C++ and having
a side passion of computer graphics, I hated the idea of doing the assignment in
Java so I rewrote the template using template programming in C++.

<!-- more -->

# Description

This template assignment was relatively easy. One of my subgoals of this project
was to make C++ more accessible to others. As such I wrote all the boilerplate
code for operator overloading and things like that, while others could just
write the bare minimum.

I have lost the actual implementation of the template when I accidentally
wiped my computer, but the template was always on gitlab. One thing that I never
ended up writing which I wish I had and might go and fix in the future was a
move constructor.

Really there is not much else to say, the entire project is pretty much one
C++ file that is less then 100 lines long.

```cpp
#include <cstdlib>

template <std::size_t M, std::size_t N>
struct Matrix {
    double data[M*N];

    // Copy values of array into data
    Matrix(const double mat[M*N]) {
        // to be completed
    }
    ~Matrix() {}

    double get(size_t i, size_t j) {
        return 0; // to be completed
    }

    size_t rowCount() { return 0; } // return number of rows
    size_t columnCount() { return 0; } // return number of columns

    bool isZero() { return true; } // return if matrix is a zero matrix
    bool isSquare() { return true; } // return if matrix is a square matrix
    bool isDiagonal() { return true; } // return if matrix is diagonal
    bool isIdentity() { return true; } // return if matrix is identity

    // Scalar addition with matrix, override the addition symbol, s for scalar
    Matrix<M, N> operator+(const double &s) const {
        return Matrix<M, N>();
    }

    // Perform matrix addition with matrix, m for matrix
    Matrix<M, N> operator+(const Matrix<M, N> &m) const {
        return Matrix<M, N>();
    }

    // Perform Scalar multiplication with matrix, s for scalar
    Matrix<M, N> operator*(const double &s) const {
        return Matrix<M, N>();
    }

    // return the negative matrix of the matrix
    Matrix<M, N> operator-() const {
        Matrix<M, N> mat;
        return ;
    }

    // set item at x, y position
    void set(double s, size_t i, size_t j) {}

    // check if indexs is valid
    bool isValid(size_t i, size_t j) {}

    // matrix multiplication
    template<std::size_t O>
        Matrix<M, O> operator*(const Matrix<N, O>) const {
            Matrix<M, O> mat;
            return mat;
        }

    // return the determinant
    double determinant() {}

    // return the minor
    Matrix<M-1, N-1> minor(size_t i, size_t j) {
        Matrix<M-1, N-1> mat;
        return mat;
    }

    // return the cofactor of the matrix
    Matrix<M, N> cofactor() {
        Matrix<M, N> mat;
        return mat;
    }

    // return the transpose of the matrix
    Matrix<N, M> transpose() {
        Matrix<N, M> mat;
        return mat;
    }

    // return the inverse of the matrix
    Matrix<M, N> inverse() {
        Matrix<M, N> mat;
        return mat;
    }

    // return if the matrix is the determinant
    bool invertible() { return true; }

    // check if matrix is equal
    bool operator==(Matrix<M, N>) { return true; }
};
```

## Sources

<https://gitlab.com/BebopBamf/matrixtemplate>