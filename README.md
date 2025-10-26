# Battery State-of-Health (SOH) Estimation — Patel & Khade (2021) Reproduction
**Author:** Aaron J. Davis  
**Course:** ECE 57000 – Artificial Intelligence - Purdue University at West Lafayette
**Checkpoint 2 (Fall 2025)**

---

## 📘 Overview
This MATLAB project reproduces the experiment described by  **[“State of Health Estimation for Lithium-Ion Batteries Based on Charging Curve and Machine Learning.”](https://doi.org/10.1109/ICEMPS60684.2024.10559327)**

The goal is to verify that simple **time-to-voltage** features extracted from **CC–CV** charging data can accurately predict **battery State of Health (SOH)**.

The project uses the [**Oxford Battery Degradation Dataset 1**](https://dx.doi.org/10.5287/bodleian:KO2kdmYGg), which provides complete time-series voltage, charge, and temperature traces across multiple cells and characterization cycles.

---

## ⚙️ Features
- **Fully automated MATLAB pipeline**
  - Extracts six time-domain features (F₁–F₆) from each charge cycle.  
  - Calculates SOH from discharge capacity relative to nominal or first-cycle reference.  
  - Evaluates each feature via independent linear regression.  
  - Produces metrics (RMSE, MAE, MAPE, R²) and regression plots.
- **Two-pass, no-growth design** — clean execution without analyzer warnings.  
- **Dataset-agnostic utilities** — reusable for other Li-ion aging datasets.

---

## 🧩 Repository Structure
├── run_oxford_checkpoint2.m          # Main driver script<br>
├── unwrap_cycle_struct.m             # Unwraps t,v,q,T tables into numeric vectors<br>
├── find_cell_capacity_ref.m          # Finds per-cell reference capacity (first C1dc)<br>
├── features_from_C1ch.m              # Extracts time-to-voltage and CC/CV features<br>
├── soh_from_C1dc.m                   # Computes cycle capacity and SOH<br>
├── evaluate_features.m               # Fits and evaluates linear regressions<br>
├── plot_soh_vs_feature.m             # Generates scatter + fit plot (RMSE, R²)<br>
├── list_cells_and_cycles.m           # Lists cells and available characterization cycles<br>
├── Oxford_Battery_Degradation_Dataset_1.mat  # Input dataset (not included in repo)<br>
├── oxford_cp2_metrics.csv            # Output: feature performance metrics<br>
├── oxford_cp2_tidy.csv               # Output: full dataset (features + SOH)<br>
└── oxford_cp2_soh_vs_F5.png          # Example regression plot


---

## 🚀 Usage

1. **Place the dataset**
   - Download from Oxford DOI link above.  
   - Put `Oxford_Battery_Degradation_Dataset_1.mat` in the repository root.

2. **Run the analysis**
   ```matlab
   >> run_oxford_checkpoint2
   ```
3. **Outputs**
   - `oxford_cp2_metrics.csv` — regression performance table
   - `oxford_cp2_tidy.csv` — compiled dataset (meta + features + SOH)
   - `oxford_cp2_soh_vs_<BestFeature>.png` — regression plot for top feature
