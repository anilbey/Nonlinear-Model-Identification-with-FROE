# Nonlinear-Model-Identification-with-FROE
This repository contains the implementation of the algorithm described in the following paper. Additionally, the report also contains the comparison of FROE models with Feed-forward Neural Networks. <br>
Korenberg, M., Billings, S.A. and Liu, Y.P. (1987) An Orthogonal Parameter Estimation Algorithm for Nonlinear Stochastic Systems.


[![DOI:10.1080/00207178808906169](https://zenodo.org/badge/DOI/10.1080/00207178808906169.svg)](https://doi.org/10.1080/00207178808906169)

## Summary

The work is consisting of performing a nonlinear model identification by using the Forward Regression Orthogonal Estimates Method with polynomial NARX models and the feed-forward neural networks and the comparison of two approaches under different model complexity assumptions.

### Identification of Polynomial NARX Models using FROE

A nonlinear autoregressive exogenous (NARX) model relates the output by the previous values of the output signal and previous values of an independent (exogenous) input signal. The generic NARX model is formulated as follows:
<br> S: y(t) = f(y(t−1), ..., y(t−n y ), u(t−1), ..., u(t−n u )) <br>
The parameter estimation problem can simply be solved by using Least Squares. In fact, the complication is to select the correct parameters of polynomial expansion to include in the model rather than estimating them. The number of possible polynomial terms increases exponentially with respect to the model order k. To evaluate a model, one has to estimate its parameters and measure its goodness of fit. However testing all the possible model structures is not feasible. Therefore many structure selection methods employ the forward regression approach. Forward selection can be speeded up even further using a technique called orthogonal least squares. This is a Gram-Schmidt orthogonalization process which ensures that each new column added to the design matrix of the growing subset is orthogonal to all previous columns.
