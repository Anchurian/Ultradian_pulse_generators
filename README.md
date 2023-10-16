# Ultradian_pulse_generators
This MATLAB program was designed for generating time series and figures for the talk  

> *Alexander N. Churilov and John G. Milton
"An Integrate-and-fire Mechanism for Modeling Rhythmicity  in the Neuroendocrine System"*
>
presented at the international conference **Big Brain 2022**,
Fudan University, Shanghai, China, November/December 2022.
Conference proceedings to be published by De Gruyter.

## Setting 
We study a new mathematical model of a hormonal axis that  comprises two coupled ultradian pulse generators. One generator is located
in the hypothalamus, the second is located in the anterior pituitary.
Two integrate-and-fire schemes are used to describe the pulse generator mechanisms. 
Depending on their firing thresholds and on the coupling gains, the system exhibits a variety of periodic or quasi-periodic behaviors.

## Schematic representation of a hormonal axis
![](https://github.com/Anchurian/Ultradian_pulse_generators/blob/main/Images/scheme.png)
Arrows and bar-headed lines indicate excitatory and inhibitory connections, respectively.
Here $H(t)$ is the input from the suprachiasmatic nucleus (SCN) of the hypothalamus,
$x(t)$, $y(t)$, $z(t)$ are serum concentrations of the hypothalamic, pituitary and target gland hormones, respectively.

## Integrate-and fire model of a single peptide hormone's release

Let $x(t)$ be the serum concentration of  a peptide  hormone,
~~~math
\dot x = -\alpha x(t) +S(t)
~~~
with the clearance coefficient $\alpha>0$  and the secretion rate given by a function $S(t)$.

Let $V(t)$ be an impulsive membrane potential.
The pulsation times $t_n$ are defined from 
~~~math 
t_0=0, \quad t_{n+1} = \min\{t \;:\; t>t_n,\quad  V(t)=\Delta\}.            
~~~
where $\Delta>0$ a given threshold. After the impulse, the potential resets to zero, i.e.
~~~math
V(t_n^+) = 0,\quad n\ge 0,
~~~
Between the impulses in membrane potential satisfies the differential equation
~~~math
\dot V = -\mu (V(t) - V_0) +  I(t),
~~~
where $I(t)$ is a consolidated input of the considered hormonal gland from some other organs,
$\mu$ and $V_0$ are positive coefficients.

The secretion rate $S(t)$ is a functional of $I(t)$ and $V(t)$, namely
~~~math
S(t)= k (I(t) + I_0) F(V(t)),
~~~
where $k$, $I_0$ are positive constants and
the $F(V)$ is a shaping function,
~~~math
F(V)  = \lambda V\,\exp(-\lambda V +1).
~~~
Here $\lambda>0$ is  a constant parameter.

These equations define a mapping
~~~math
G_{p}\;:\; I(t) \mapsto x(t)
~~~
with a vector of parameters
~~~math
p = \{\, I_0,\; V_0,\; \alpha,\; \lambda,\; \mu,\; k, \; \Delta \,\}.
~~~

## Mathematical model of a regulation loop consisting of three hormones

Let $x(t)$, $y(t)$, $z(t)$ be serum concentrations of the hypothalamic, pituitary 
and target gland hormones, respectively.

#### Hypothalamic pulse generator.
Use a pulse generator described in the previous section with a vector of parameters $p_1$:
~~~math
G_{p_1}\;:\; I_1(t) \mapsto x(t),\quad  p_1 = \{\, I_0^{(1)},\; V_0^{(1)},\; \alpha_1,\; \lambda_1,\; \mu_1,\; k_1, \; \Delta_1 \,\}.
~~~
The input function $I_1(t)$ is 
~~~math
I_1(t) = (1+H(t))\, L_1(z(t)).
~~~
\end{equation}
and contains two components: a modulating input, $H(t)$, and an inhibitory input, $L_1(z(t))$.
The feedback function $L_1(z)$ obeys Michaelis-Menten  kinetics 
~~~math
L_1(z)  = \frac{1}{1 + z/h_1},
~~~
where $h_1>0$ is a parameter.
The function $H(t)$ is the modulating input from the suprachiasmatic nucleus of the hypothalamus.
In the simplest case it can be chosen harmonic.

#### Pituitary pulse generator.
Consider the pulse generator with a vector of parameters $p_2$
~~~math
G_{p_2}\;:\; I_2(t) \mapsto y(t),\quad  p_2 = \{\, I_0^{(2)},\; V_0^{(2)},\; \alpha_2,\;\lambda_2,\; \mu_2,\;  k_2, \; \Delta_2 \,\}.
~~~
The input function $I_2(t)$ is 
~~~math
I_2(t) =  x(t)\, L_2(z(t)),
~~~
where $x(t)$ is an excitatory input and and $L_2(z(t))$ is an inhibitory input described by a decreasing positive function,
which can also be taken Michaeles-Menten.

#### Target gland hormonal release.   
Suppose that the target hormone is released continuously, following a linear differential equation
~~~math
\dot z = -\alpha_3 z + k_3 y,
~~~
where $\alpha_3$, $k_3$ are positive parameters.

## Simulations
The depository contains a MATLAB program for simulating and drawing hormonal profiles.
The simulations are illustrated with figures pic01.png, pic02.png, pic03.png given in Images folder.
***
![Hormonal profiles for isolated hypothalamic and pituitary hormonal generators.](https://github.com/Anchurian/Ultradian_pulse_generators/blob/main/Images/pic1.png)
Hormonal profiles for isolated hypothalamic and pituitary hormonal generators.
***
![Hormonal profiles for the lesioned circadian input.](https://github.com/Anchurian/Ultradian_pulse_generators/blob/main/Images/pic2.png)
Hormonal profiles for the lesioned circadian input.
***
![Hormonal profiles for the circadian input.](https://github.com/Anchurian/Ultradian_pulse_generators/blob/main/Images/pic3.png)
Hormonal profiles for the circadian input.
***
## Our previous publications on integrate-and-fire models

1. *A. N. Churilov, J. Milton, and E. R. Salakhova.*
An integrate-and-fire model for pulsatility in the neuroendocrine
  system.
*Chaos (AIP journal)*, **30**(8):083132, 2020.

2. *A. N. Churilov and J. G. Milton.*
Modeling pulsativity in the hypothalamic-pituitary-adrenal hormonal axis.
*Scentific Reports*, **12**:8480, 2022.
