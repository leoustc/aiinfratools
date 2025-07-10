FROM ubuntu:22.04

# Basic tools and dependencies
RUN apt-get update && \
    apt-get install -y curl unzip python3 python3-pip python3-venv git && \
    rm -rf /var/lib/apt/lists/*

# Setup virtual environment for OCI
ENV VENV=/opt/oci
RUN python3 -m venv ${VENV}
RUN ${VENV}/bin/pip install --upgrade pip

# Install jupyterlab and its dependencies    
# Disable password, allow root, restrict to local (or open as you wish)
ENV JUPYTER_ENABLE_LAB=yes
ENV JUPYTER_ALLOW_ROOT=true
ENV JUPYTER_PORT=8888

RUN ${VENV}/bin/pip install jupyterlab jupyterlab_git
# Remove Python & bash kernels (so no notebook execution)
RUN rm -rf ${VENV}/share/jupyter/kernels \
    && rm -rf /usr/local/share/jupyter/kernels \
    && rm -rf /root/.local/share/jupyter/kernels \
    && mkdir -p /workspace
RUN ${VENV}/bin/pip uninstall -y notebook nbclassic ipykernel ipython
# JupyterLab config: only File Browser + Terminal, hide other stuff
RUN mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/launcher-extension/ \
    && echo '{ "displayed": false }' > /root/.jupyter/lab/user-settings/@jupyterlab/launcher-extension/plugin.jupyterlab-settings

# Install OCI CLI in the virtual environment
RUN ${VENV}/bin/pip install oci-cli
RUN ln -s ${VENV}/bin/oci /usr/local/bin/oci

# 
ENV SHELL=/bin/bash
RUN echo "source /opt/oci/bin/activate" >> /root/.bashrc
RUN chsh -s /bin/bash root

# Install OCI Terraform provider
COPY scripts/install-terraform.sh /tmp/install-terraform.sh
RUN chmod +x /tmp/install-terraform.sh
RUN /tmp/install-terraform.sh && rm -f /tmp/install-terraform.sh

# Working directory
WORKDIR /workspace
RUN mkdir -p /workspace/project
RUN git config --global user.name "AI Infra Tools User" && git config --global user.email ""
RUN cd /workspace/project && git init
COPY scripts/gitignore /workspace/project/.gitignore
RUN cd /workspace/project && git add /workspace/project/.gitignore && git commit -m "Initial commit with .gitignore"

# Expose JupyterLab port
EXPOSE ${JUPYTER_PORT}

# Entrypoint: Open shell
CMD ["/opt/oci/bin/jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--LabApp.token=''", "--LabApp.password=''"]