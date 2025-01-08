# Use a known public base image for Jupyter
FROM jupyter/base-notebook:python-3.10.9

# Set environment variables
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Create a non-root user (necessary for Binder)
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Copy repository contents into the container
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Install required JupyterLab extensions and other packages
RUN pip install --no-cache-dir \
    jupyterlab==3.4 \
    jupyterlab-feedback==0.6.2 \
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

# Copy the Juxl configuration settings into the container
COPY --chown=1000 juxl.jupyterlab-settings /opt/conda/share/jupyter/lab/settings/overrides.json

# Allow cross-origin requests from the Juxl authentication server
RUN echo "c.NotebookApp.allow_origin = 'https://juxlauth.elearn.rwth-aachen.de'" >> /etc/jupyter/jupyter_notebook_config.py

# Set the default command to start JupyterLab
CMD ["start-notebook.sh"]
