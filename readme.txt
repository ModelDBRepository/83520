This is the readme for the model associated with the paper

Bruce A. Carlson and Masashi Kawasaki (2006)
Ambiguous Encoding of Stimuli by Primary Sensory
Afferents Causes a Lack of Independence in the Perception of
Multiple Stimulus Attributes
J Neurosci 26(36):9173-9183

Abstract:

Accurate sensory perception often depends on the independent encoding
and subsequent integration of multiple stimulus attributes. In the
weakly electric fish Eigenmannia, P- and T-type primary afferent
fibers are specialized for encoding the amplitude and phase,
respectively, of electrosensory stimuli. We used a stimulus estimation
technique to quantify the ability of P- and T-units to encode random
modulations in amplitude and phase. As expected, P-units exhibited a
clear preference for encoding amplitude modulations, whereas T-units
exhibited a clear preference for encoding phase
modulations. Surprisingly, both types of afferents also encoded their
nonpreferred stimulus attribute when it was presented in isolation or
when the preferred stimulus attribute was sufficiently weak.  Because
afferent activity can be affected by modulations in either amplitude
or phase, it is not possible to unambiguously distinguish between
these two stimulus attributes by observing the activity of a single
afferent fiber. Simple model neurons with a preference for encoding
either amplitude or phase also encoded their nonpreferred stimulus
attributewhenit was presented in isolation, suggesting that such
ambiguity is unavoidable. Using the well known jamming avoidance
response as a probe of electrosensory perception, we show that the
ambiguity at the single-neuron level gives rise to a systematic
misrepresentation of stimuli at the population level and a resulting
misperception of the amplitude and phase of electrosensory stimuli.

Usage notes:

The archive has all the Matlab and Simulink files needed to run the
leaky integrate-and-fire models from our J Neurosci paper. To run the
models, the user should type "PrimAff_IntFire" at the Matlab command
prompt. This will open a GUI that allows the user to set the
parameters of the model, run the simulation, and plot the resulting
spike train and stimulus. The option to "View Simulation in Action",
when checked, runs the simulation in Simulink, so that the user can
actually watch the simulation on an oscilloscope, rather than just
receive the output of the simulation. The Matlab model is
"liandfrn.m", the Simulink version uses "liandfrn_sim.m" and
"PrimAff.mdl". "genstim.m" is a script for generating the stimulus,
"modsine.m" is a function for generating sinusoidal stimulus
modulations, and "blim_whnoise.m" is a function for generating random
stimulus modulations.
