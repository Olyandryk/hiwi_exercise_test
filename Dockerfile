# Specify parent image with a fixed tag for reproducibility
FROM jupyter/base-notebook:python-3.10.9

# Set environment variables
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Create the non-root user
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Copy repository contents to the container
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Install JupyterLab and extensions
RUN pip install --no-cache-dir \
    jupyterlab==3.4 \
    jupyterlab_feedback==0.6.2 \
    jupyterlab-hide-cells==3.0.1 \
    openai \
    nbgitpuller \
    jupyterlab_autorun_cells \
    pandas==2.2.1 \
    scikit-learn==1.1 \
    scipy \
    matplotlib==3.5 \
    pillow \
    numpy>=1.23 \
    unidecode==1.3.8 \
    cvxopt==1.3

# Install Juxl extensions
RUN jupyter labextension install \
    @juxl/juxl-extension@^3.1.1 \
    @juxl/logging@^3.1.1

# Copy the Juxl configuration settings
COPY --chown=1000 overrides.json /opt/conda/share/jupyter/lab/settings/overrides.json

# Configure Jupyter Notebook to allow origins
RUN echo "c.NotebookApp.allow_origin = 'https://juxlauth.elearn.rwth-aachen.de'" >> /etc/jupyter/jupyter_notebook_config.py

# Set the default command to start JupyterLab
CMD ["start-notebook.sh"]
