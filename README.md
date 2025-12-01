# Computational Biomedical Research

This repository collects my computational work for the lab, spanning data-driven analyses, reproducible workflows, and method development across biomedical and public-health domains. The focus is on building transparent, well-documented analysis pipelines and lightweight research tools that support the lab’s broader mission: using computational methods to advance biomedical research.

The projects here include exploratory analyses, methodological demos, prototype software tools, and documentation that help standardize and accelerate computational research across ongoing lab initiatives.

---

## Repository Structure

```text
.
├── spatial-transcriptomics/
│   ├── seurat-demo/
│   └── spatiallibd-demo/
└── README.md
```

---

## spatial-transcriptomics/

This directory contains analysis workflows and demos related to spatial transcriptomics.

### seurat-demo/

A Seurat-based Visium workflow demonstrating:

- quality control  
- normalization  
- dimensionality reduction (PCA, UMAP)  
- clustering  
- spatial visualization  
- marker identification  

Contents include:

- `seurat_demo.Rmd` — source notebook  
- `seurat_demo.html` — knitted, viewable analysis  
- `figures/` — exported plots  
- `README.md` — instructions and description

### spatiallibd-demo/

A demonstration using the **spatialLIBD** package for:

- exploratory visualization  
- interactive spatial plots  
- preliminary inspection of spatial gene expression  

Contents include:

- `spatiallibd_demo.Rmd` - source notebook  
- `spatiallibd_demo.html` - knitted, viewable analysis  
- `figures/` - exported plots
- `README.md` — instructions and description

---

## Data Policy

Raw datasets are *not* included in this repository.  
Users must download required data from the original source (for example, 10x Genomics) and place it in a local `data/` directory, which is intentionally ignored by Git.

Project READMEs include links to the datasets needed for each demo.

---

## Reproducibility

Each analysis folder contains:

- a source notebook (`.Rmd` or `.qmd`)  
- a knitted HTML file for immediate viewing  
- clear instructions on how to re-run the workflow  
- a `figures/` directory  
- session information at the end of the notebook  

This structure ensures that each project is fully self-contained and reproducible.
