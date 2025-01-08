# Use a specific base image tag, not 'latest'
# You can find a stable tag on the repository for the base image
FROM jupyter/base-notebook:latest

# Set user and user ID
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Add the user jovyan with UID 1000
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Switch to jovyan user
USER ${NB_USER}

# Install required system dependencies, including JupyterLab
RUN pip install --no-cache-dir jupyterlab==3.4.0

# Install JupyterLab extensions
RUN jupyter labextension install \
    @juxl/juxl-extension@^3.1.1 \
    @juxl/logging@^3.1.1 

# Set up overrides.json for juxl extension
COPY --chown=${NB_UID}:${NB_UID} juxl.jupyterlab-settings /opt/conda/share/jupyter/lab/settings/overrides.json

# Configure Jupyter Notebook to allow the correct origin (for juxl authentication)
RUN echo "c.NotebookApp.allow_origin = 'https://juxlauth.elearn.rwth-aachen.de'" >> /etc/jupyter/jupyter_notebook_config.py

# Install jupyterlab-feedback extension (llm)
COPY jupyterlab_feedback-0.6.2-py3-none-any.whl .
RUN pip install jupyterlab_feedback-0.6.2-py3-none-any.whl

# Default command to run JupyterLab
CMD ["jupyter", "lab", "--NotebookApp.default_url=/lab", "--ip=0.0.0.0", "--port=8888"]
