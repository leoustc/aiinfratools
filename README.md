# aiinfratools
AI Infra Tools to Management Infrastructure

This repository contains GitHub Actions workflows to build and push multiple Docker images for AI infrastructure tools to DockerHub using a matrix strategy.

## Overview

- **Automated CI/CD**: On every push to the `main` branch or manual trigger, the workflow builds and pushes Docker images for different tools.
- **Matrix Build**: Supports building multiple Dockerfiles (e.g., `mini`, `oci`, `terraform`) in parallel.
- **DockerHub Integration**: Images are tagged and published to your DockerHub account.

## Workflow Details

- **Workflow File**: `.github/workflows/dockerhub-matrix.yml`
- **Triggers**: 
  - Pushes to `main`
  - Manual dispatch via GitHub Actions UI
- **Dockerfiles Supported**:
  - `Dockerfile.mini` → `:mini` tag
  - `Dockerfile.oci` → `:oci` tag
  - `Dockerfile.terraform` → `:terraform` tag

## How It Works

1. **Checkout Source**: Clones the repository.
2. **Set up Docker Buildx**: Enables advanced Docker build features.
3. **Login to DockerHub**: Uses GitHub secrets for authentication.
4. **Extract Metadata**: Sets image tags and labels.
5. **Build and Push**: Builds each Dockerfile and pushes the image to DockerHub.

## DockerHub Image Tags

Images are pushed to:

```
docker.io/<your-dockerhub-username>/aiinfra-tools:<tag>
```

Where `<tag>` is one of: `mini`, `oci`, `terraform`.

## Requirements

- Set the following GitHub repository secrets:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_TOKEN`

## Example Usage

To trigger the workflow, push to the `main` branch or use the "Run workflow" button in the Actions tab.

## Customization

- To add more Dockerfiles, update the `matrix.include` section in `.github/workflows/dockerhub-matrix.yml`.
- To change image names or tags, edit the `IMAGE_NAME` and `tag` fields.

##