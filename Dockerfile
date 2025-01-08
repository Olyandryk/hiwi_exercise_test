# Specify the parent image. Please select a fixed tag here.
ARG BASE_IMAGE=registry.git.rwth-aachen.de/jupyter/profiles/rwth-courses:latest
FROM ${BASE_IMAGE}

# Add environment.yml for conda dependencies
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && \
    conda clean -a

# Activate the environment
ENV PATH /opt/conda/envs/codingai/bin:$PATH

# Install JupyterLab extensions (Juxl and Logging)
RUN jupyter labextension install \
    @juxl/juxl-extension@^3.1.1 \
    @juxl/logging@^3.1.1

# Copy the Juxl overrides.json file for configuration
COPY --chown=1000 juxl.jupyterlab-settings /opt/conda/share/jupyter/lab/settings/overrides.json

# Modify Jupyter configuration to allow origin from the LRS (Learning Record Store)
RUN echo "c.NotebookApp.allow_origin = 'https://juxlauth.elearn.rwth-aachen.de'" >> /etc/jupyter/jupyter_notebook_config.py

# Add the feedback extension (llm)
ADD jupyterlab_feedback-0.6.2-py3-none-any.whl /tmp/
RUN pip install /tmp/jupyterlab_feedback-0.6.2-py3-none-any.whl

# Add postBuild script to build and verify JupyterLab extensions
COPY postBuild /usr/local/bin/postBuild
RUN chmod +x /usr/local/bin/postBuild

# Expose port 8888 for JupyterLab
EXPOSE 8888

# Set the default command to run JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root"]
