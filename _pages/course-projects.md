---
layout: archive
title: "Course projects"
permalink: /course-projects/
author_profile: true
---

Smaller projects from my coursework at UT Dallas and UW–Platteville, grouped by area. My larger design projects are on the [Research](/research/#design-projects) page.

Machine learning
------
* **ID3 decision tree from scratch** (2020). Built a decision tree classifier without machine learning libraries: entropy and information gain to choose each split, recursive tree construction, test-error evaluation, and a GraphViz drawing of the learned tree.
* **Polynomial and radial basis function regression** (2020). Fit a noisy sinusoid two ways, with least-squares polynomial regression (Vandermonde matrices) and ridge regression on radial basis features, and compared training, validation, and test error as model complexity grew.
* **SVM and k-nearest neighbors comparison** (2020). Studied how the C and gamma settings of a radial-basis-kernel support vector machine trade training error against validation error, then compared the tuned model with k-nearest neighbors on the same data.
* **Spam classification** (2020). Implemented Naive Bayes and L2-regularized logistic regression (gradient ascent) on term-frequency features to separate spam from legitimate email, and measured the effect of removing stop words.

Signal processing
------
* **IIR and adaptive FIR filters on Android** (2021). Moved MATLAB filter designs into a real-time Android app, compared direct-form and second-order-section IIR filters, and watched how step size and frame size change the convergence of an adaptive (LMS) FIR filter.
* **FFT versus DFT in real time** (2021). Implemented both transforms for live audio on an Android device and measured how frame size and sampling rate change per-frame processing time.

FPGA and digital design
------
* **PicoBlaze soft processor on a Spartan-6** (2019). Wrote PicoBlaze assembly for LED patterns and for arithmetic on DIP-switch inputs shown on 7-segment displays, built the design in Xilinx ISE, and verified it with testbenches before loading it on the board.
* **Ackermann function in hardware** (2019). Used high-level synthesis (Vivado HLS) to turn C into an IP block for a Zybo Zynq board, co-simulated the C and register-transfer-level versions, and drove the block from the ARM core over UART.
* **Euclid's greatest common divisor in hardware** (2019). The same hardware/software flow on the Zybo board, comparing hardware and software execution times.

Microcontrollers and embedded systems
------
* **Analog-to-digital conversion and low-power modes on the MSP430** (2019). Configured the 12-bit converter in both polling and interrupt modes, displayed results on an LCD, and confirmed the low-power modes on an oscilloscope.
* **GPIO, interrupts, and an LCD menu on the MSP430** (2019). Built a button-driven menu on the MSP430F5529 board with one button polled and one interrupt-driven, to show the difference between the two.
* **Smart blinds** (2019, team project). Automated window blinds that respond to light, with manual override. I designed the rotary-sensor signal-conditioning circuit, wrote ESP32 firmware that reads the sensors and reports to Microsoft Azure, and handled integration, calibration, and the cost analysis.

Circuits
------
* **Common-emitter amplifier** (2017). Designed a 2N3904 transistor amplifier to a gain and output-swing specification, simulated it, then built and measured it.
* **Full-wave rectifier** (2017). Designed a four-diode bridge rectifier with a smoothing capacitor to a ripple specification; the measured output of 7.76 V was close to the 7.6 V calculated.

Software
------
* **Bank account manager** (2017). A C++ program that handles accounts, deposits, withdrawals, and interest across three banks, with password checks and error handling.
* **Inventory manager** (2017). A C++ program that adds, sells, orders, and sorts inventory items and tracks profit, using parallel arrays and selection sort.
