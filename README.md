# AI Infra Tools - Admin

A collection of modular Docker images for AI infrastructure automation and management, supporting Oracle Cloud (OCI), Terraform, and Kubernetes (kubectl & helm) workflows.

---

## Overview

This repository provides several Docker images to streamline AI infrastructure tasks, including a minimal JupyterLab environment, Oracle Cloud CLI, Terraform automation, and Kubernetes tooling. Images are published to DockerHub as:

- `leoustc/aiinfra-tools:mini`
- `leoustc/aiinfra-tools:oci`
- `leoustc/aiinfra-tools:terraform`
- `leoustc/aiinfra-tools:k8s`

## Available Images

| Dockerfile              | DockerHub Tag                     | Description                                                        |
|-------------------------|-----------------------------------|--------------------------------------------------------------------|
| `Dockerfile.mini`       | `leoustc/aiinfra-tools:mini`      | Minimal JupyterLab image with terminal, no notebook execution.      |
| `Dockerfile.oci`        | `leoustc/aiinfra-tools:oci`       | Adds Oracle Cloud CLI tools to the base image.                      |
| `Dockerfile.terraform`  | `leoustc/aiinfra-tools:terraform` | Adds Terraform and OCI Terraform provider on top of OCI.            |
| `Dockerfile.k8s`        | `leoustc/aiinfra-tools:k8s`       | Adds kubectl and helm for Kubernetes management on top of Terraform.|

---

## Usage

### Pulling Images

```sh
docker pull leoustc/aiinfra-tools:<tag>
```
Replace `<tag>` with `mini`, `oci`, `terraform`, or `k8s`.

---

### Mini JupyterLab Image (`mini` tag)

The `mini` image provides a lightweight JupyterLab environment with only the file browser and terminal enabled. Notebook execution is disabled for security and minimalism.

#### Run JupyterLab

```sh
docker run -it --rm -p 8888:8888 leoustc/aiinfra-tools:mini
```

- Access JupyterLab at: [http://localhost:8888](http://localhost:8888)
- No token or password is required.
- Only the file browser and terminal are available; notebook execution is disabled.

#### Volumes

To persist files or access local directories, mount them as volumes:

```sh
docker run -it --rm -p 8888:8888 -v $(pwd):/workspace leoustc/aiinfra-tools:mini
```

---

### Using with Docker Compose

Example `docker-compose.yml` for running the OCI, Terraform, or K8s containers and sharing your local OCI credentials:

```yaml
version: '3.8'

services:
  oci:
    image: leoustc/aiinfra-tools:oci
    container_name: oci-tools
    volumes:
      - ~/.oci:/root/.oci      # Share your OCI credentials
      - .:/workspace          # Share your project directory
    working_dir: /workspace
    stdin_open: true
    tty: true

  terraform:
    image: leoustc/aiinfra-tools:terraform
    container_name: terraform-tools
    volumes:
      - ~/.oci:/root/.oci      # Share your OCI credentials
      - .:/workspace          # Share your Terraform configs
    working_dir: /workspace
    stdin_open: true
    tty: true

  k8s:
    image: leoustc/aiinfra-tools:k8s
    container_name: k8s-tools
    volumes:
      - ~/.kube:/root/.kube    # Share your kubeconfig for kubectl/helm
      - .:/workspace           # Share your project directory
    working_dir: /workspace
    stdin_open: true
    tty: true
```

**Notes:**
- Ensure your OCI config and API key are present in `~/.oci` on your host for OCI/Terraform images.
- Ensure your kubeconfig is present in `~/.kube` for the k8s image.
- Your current directory (`.`) is mounted as `/workspace` in the container.
- Adjust services and volumes as needed for your setup.

#### Start a shell in the container

```sh
docker compose run --rm oci
# or
docker compose run --rm terraform
# or
docker compose run --rm k8s
```

---

## CI/CD

- Images are built and pushed to DockerHub via GitHub Actions on every push to `main` or on release.
- Build order: `mini` → `oci` → `terraform` → `k8s`.

---

## Customization

To add a new image:
1. Create a new Dockerfile (e.g., `Dockerfile.mynew`).
2. Add corresponding build and push steps in your CI workflow.
3. Tag and document the new image in this README.

---

## License

This project is licensed under the GNU General Public License v2.0 (GPLv2).  
See [LICENSE](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) for details.

---