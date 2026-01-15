/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_predictPKBNN_api.h
 *
 * MATLAB Coder version            : 25.2
 * C/C++ source code generated on  : 08-Dec-2025 22:03:22
 */

#ifndef _CODER_PREDICTPKBNN_API_H
#define _CODER_PREDICTPKBNN_API_H

/* Include Files */
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void predictPKBNN(real32_T x[4], real32_T soh_data[], int32_T soh_size[2]);

void predictPKBNN_api(const mxArray *prhs, const mxArray **plhs);

void predictPKBNN_atexit(void);

void predictPKBNN_initialize(void);

void predictPKBNN_terminate(void);

void predictPKBNN_xil_shutdown(void);

void predictPKBNN_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for _coder_predictPKBNN_api.h
 *
 * [EOF]
 */
