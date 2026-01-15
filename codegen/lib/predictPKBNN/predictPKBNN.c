/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: predictPKBNN.c
 *
 * MATLAB Coder version            : 25.2
 * C/C++ source code generated on  : 08-Dec-2025 22:03:22
 */

/* Include Files */
#include "predictPKBNN.h"
#include "CompactRegressionNeuralNetwork.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * PREDICTPKBNN  Entry point for code generation for F2_F4F6_BNN.
 *    x : 1x4 row vector of predictors [F2 F4 F5 F6]
 *    soh : scalar predicted SOH (%)
 *
 * Arguments    : const float x[4]
 *                float soh_data[]
 *                int soh_size[2]
 * Return Type  : void
 */
void predictPKBNN(const float x[4], float soh_data[], int soh_size[2])
{
  /*  Load the regression neural network saved with saveLearnerForCoder */
  /*  Predict SOH */
  c_CompactRegressionNeuralNetwor(x, soh_data, soh_size);
}

/*
 * File trailer for predictPKBNN.c
 *
 * [EOF]
 */
