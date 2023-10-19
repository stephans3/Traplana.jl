# Traplana

<!--[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://stephans3.github.io/Traplana.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://stephans3.github.io/Traplana.jl/dev/)
[![Build Status](https://github.com/stephans3/Traplana.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/stephans3/Traplana.jl/actions/workflows/CI.yml?query=branch%3Amain)-->

Traplana is Julia library for trajectory planning based on simple reference signals using
* cosine: $r(t)=(1 - \cos(p~\pi~t))/2$
* tanh: $r(t)=(1+\tanh(p*(t-0.5)))/2$

The input signal is computed with the reference signal and its derivatives

$u(t)=f(r, \dot{r}, ..., r^{(n-1)})$


## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
