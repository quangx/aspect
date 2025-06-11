#Solver

The Stokes system we are solving is of the
form

```{math}
:label: eq:aligned
    Mx&=\begin{pmatrix}A & B^T \\
    B & 0
    \end{pmatrix}
    \begin{pmatrix} u\\
    p
    \end{pmatrix} =
    \begin{pmatrix}
    f \\
    0
    \end{pmatrix}
```

. Here, $A$ is the viscous stress matrix,
$B^T$ comes from integrating 
grad on pressure space by parts after
testing with $v$, and $B$ comes from
integrating div $u$ by parts after testing
with $q$.


We have a right preconditioner of the form
```{math}
:label: eq:aligned
    P^{-1}&=\begin{pmatrix}
    A^{-1} & A^{-1}B^TS^{-1} \\
    0      & -S^{-1}
    \end{pmatrix}
```
.

The motivation for this is that

```{math}
    :label: eq:aligned
    MP^{-1}&= \begin{pmatrix}
    AA^{-1} & B^TS^{-1}-B^TS^{-1 } \\
    BA^{-1} & BA^{-1}B^TS^{-1}
    \end{pmatrix} \\
    &\approx
    \begin{pmatrix}
    I & 0 \\
    BA^{-1} & I
    \end{pmatrix}
```.

Notice that in the top left block $AA^{-1}=I$ and in the bottom right block $BA^{-1}B^TS^{-1} - 
we want to choose $S$ such that $S^{-1} \approx BA^{-1}B^T$. Note that 
this $BA^{-1}B^T$ is often referred to as the Schur Complement.

Pressure Scaling: ASPECT uses dimensionalized units
and a pressure scaling factor is required in
order to ensure the iterative
solver enforces both 
equations in the Stokes system. 
The pressure scaling factor
is computed
based on viscosity and other parameters.

An iterative method such as GMRES will continue iteration until
```{math}
\lvert\lvert\begin{pmatrix}
    F_u-AU^{(k)}-B^TP^{(k)} \\
    BU^{(k)}
\end{pmatrix}\rvert\rvert< \text{ tol }.
```

We must note that the $U$ block corresponding to velocity and 
$P$ block corresponding to pressure will 
have different units, and this generally leads 
to one of the equations,
likely $\text{div}\mathbf{u}=0$ not being enforced.

In particular, the residual of the first block
has associated units $\frac{Pa}{m} m^{\text{dim}}$
where $Pa=\frac{kg}{ms^2}$
and the second block has units $\frac{m^{\text{dim}}}{s}$.


To remedy this, we recall our Stokes system of the form
```{math}
:label: eq:aligned
        -\nabla \cdot (2 \eta(x)
        \varepsilon(u))+\nabla p & = f\\
        \nabla \cdot u&=0.
```
We introduce the pressure scaling $\lambda:=\frac{\eta}{L}$ and scale $\nabla \cdot u$ as follows:

```{math}
:label: eq:aligned
 \lambda \nabla \cdot u =0,
```

where $L$ is determined by a variety of 
factors (size of domain,
viscosity contrasts,etc).

However, notice that this destroys the symmetry we have in our block Stokes matrix
with the $B$ block. To remedy this, let $\widehat{p}=\lambda^{-1}p$ \cite{2024:africa.arndt.ea:deal}\cite{kronbichler:etal:2012}.
Then we can rewrite our system as 

```{math}
:label: eq:aligned
    -\nabla \cdot (2 \eta \varepsilon(u))+\nabla (\lambda \widehat{p})  = f \quad&x \in \Omega\\
    \lambda \nabla \cdot u=0 \quad& x \in \Omega.
```