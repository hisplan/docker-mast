# docker-mast

Dockerized MAST (Model-based Analysis of Single-cell Transcriptomics) for computing genes that are differentially expressed in each cluster compared to the rest of the data.

## How to Compute Differentially Expressed Genes

`prepare-MAST.ipynb` takes a h5ad file and generates:

```
df.0.RDS
df.0.rest.RDS
df.0.tgz
.
.
.
df.n.RDS
df.n.rest.RDS
df.n.tgz
```

where `0..n` is the cluster number.

`df.n.tgz` is a tarball gzipped of two files: `df.n.RDS` and `df.n.rest.RDS`.

The reason is to analyze each cluster in parallel way (rather than passing the entire h5ad or RDS to each worker).

`pairwise-diffexp.R` takes two arguments:

- cluster number
- output CSV filename

For example, if you specify cluster number 5, it will load `df.1.RDS` and `df.1.rest.RDS` and compute the genes that are differentially expressed in cluster 5 compared to the rest of the data.

## Running Notebook

```bash
./run-notebook.sh
```

## Build Container Image

```bash
./build.sh
```

## Push to Docker Registry

Either you can use the `docker push` command or run `push.sh` (requires [SCING](https://github.com/hisplan/scing)):

```bash
./push.sh
```
