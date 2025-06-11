#Solver

The Stokes system we are solving is of the
form

\[
    Mx=\begin{pmatrix}A & B^T \\
    B & 0
    \end{pmatrix}
    \begin{pmatrix} u\\
    p
    \end{pmatrix} =
    \begin{pmatrix}
    f \\
    0
    \end{pmatrix}
\].

We have a right preconditioner of the form
\[
    P^{-1}=\begin{pmatrix}
    A^{-1} & A^{-1}B^TS^{-1} \\
    0      & -S^{-1}
    \end{pmatrix}
\].

The motivation for this is that

\[
    MP^{-1}&= \begin{pmatrix}
    AA^{-1} & B^TS^{-1}-B^TS^{-1 } \\
    BA^{-1} & BA^{-1}B^TS^{-1}
    \end{pmatrix} \\
    &\approx
    \begin{pmatrix}
    I & 0 \\
    BA^{-1} & I
    \end{pmatrix}
]

Notice that in the top left block $AA^{-1}=I$ and in the bottom right block $BA^{-1}B^TS^{-1} - 
we want to choose $S$ such that $S^{-1} \approx BA^{-1}B^T$. Note that 
this $BA^{-1}B^T$ is often referred to as the Schur Complement.