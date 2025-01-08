# Use a public Jupyter Docker Stack image compatible with MyBinder
ARG BASE_IMAGE=jupyter/base-notebook:latest
FROM ${BASE_IMAGE}

# Install Juxl extensions (Learning Analytics)
RUN jupyter labextension install \
    @juxl/juxl-extension@^3.1.1 \
    @juxl/logging@^3.1.1

# Configure Juxl
COPY --chown=1000 juxl.jupyterlab-settings /opt/conda/share/jupyter/lab/settings/overrides.json
RUN echo "c.NotebookApp.allow_origin = 'https://juxlauth.elearn.rwth-aachen.de'" >> /etc/jupyter/jupyter_notebook_config.py

# Install LLM Feedback extension
ADD jupyterlab_feedback-0.6.2-py3-none-any.whl .
RUN pip install jupyterlab_feedback-0.6.2-py3-none-any.whl
