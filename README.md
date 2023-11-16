# Modelling-Thermodynamics
In this project, I modelled a ternary mixture of benzene, cyclohexane and acetone. The project involved using an activity coefficient model to predict vapour liquid equilibrium of the mixture. In particular, for each composition, I was tasked with modelling the temperature at which the bubble point occurs.

These values are saved in a matrix. This is then plotted in 3D dimensions, so that an engineer can understand the behaviour of the system easily. Additionally, azeotropes were identified by finding where the vapour and liquid compositions are the same.

For values where the composition exceeds 100%, e.g. 60% acetone, 60% cyclohexane, a bubble point temperature of 0 is recorded, to easily remove these points later. This is hence why the graph has a triangular shape from above: the composition values must sum to 100%: the composition of the first two componenets is plotted on the x and y axes, and the mol fraction of the last component is inferred from the difference
