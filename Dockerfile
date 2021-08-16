FROM quay.io/hisplan/scri-notebook:0.0.3

COPY scripts/*.R /opt/

RUN Rscript /opt/install.R

COPY scripts/*.ipynb /opt/
