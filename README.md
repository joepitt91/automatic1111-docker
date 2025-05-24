<!--
SPDX-FileCopyrightText: 2025 Joe Pitt

SPDX-License-Identifier: GPL-3.0-only
-->
# AUTOMATIC1111 Docker Image

Docker image of
[AUTOMATIC1111 Stable Diffusion Web UI.](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
running on Python 3.10.

Images are available of v1.7.0 and later.

To use CUDA you must have a Docker host (Docker Desktop or a server) with the appropriate hardware
support in place, these links may help you get started:

* [Getting Started | Docker](https://www.docker.com/get-started/)
* [Enable GPU support | Docker Docs](https://docs.docker.com/compose/how-tos/gpu-support/)

## Getting Started

To run AUTOMATIC1111:

1. Download `docker-compose.yml` to a suitable directory on your Docker host.
    * To build the image locally, download `docker-compose.build.yml` instead and rename it to
        `docker-compose.yml`. You will also need to set `A1111_VERSION` inside the file to the
        desired AUTOMATIC1111 version (with preceding `v`).
2. Open a terminal in the chosen directory.
3. Start the service by running:

```sh
docker compose up -d
```

4. Monitor the container's startup by running:

```sh
docker compose logs -f
```

5. Once `Running on local URL:  http://0.0.0.0:7860` is logged by the container, AUTOMATIC1111
    should be accessible at http://localhost:7860/ from the Docker host.

## Installing Models and Other Files

Once AUTOMATIC1111 is running, you may want to install specific models or add other content.

The easiest way to do this is to install an extension to manage models with, however to do this
manually copy files into the persisted `data` volume using the following command syntax:

```sh
docker compose cp ./v1-5-pruned-emaonly.safetensors comfyui:/data/models/Stable-diffusion/
```

The initial directory structure of `/data` after first start up is:

```
/
└── data
    ├── cache
    │   ├── hashes
    │   └── safetensors-metadata
    ├── extensions
    └── models
        ├── Codeformer
        ├── GFPGAN
        ├── hypernetworks
        ├── Lora
        └── Stable-diffusion
```

Additional directories will be created as needed during use.

## Network Access

By default, AUTOMATIC1111 is only available on the docker host, to allow network access edit 
`docker-compose.yml` - replacing `- 127.0.0.1:7860:7860` with `- '7860:7860'` - and restart the
container by running:

```sh
docker compose up -d --force-recreate
```

Once complete, AUTOMATIC1111 should be accessible at http://{docker host IP / FQDN}:7860/.

**NOTE:** If a host-based firewall is present on the Docker host, or a network firewall is between
the docker host and clients, rules will need to be added to allow access.

## More Details

### Image Tags

There are four types of tags applied to the images:

| Type | Example | Referenced Version |
|------|---------|--------------------|
| Latest | `ghcr.io/joepitt91/automatic1111:latest` | The latest release. |
| Major | `ghcr.io/joepitt91/automatic1111:1` | The latest v1.x.x release. |
| Minor | `ghcr.io/joepitt91/automatic1111:1.10` | The latest v1.10.x release |
| Patch | `ghcr.io/joepitt91/automatic1111:1.10.1` | Specifically v1.10.1 |

### Environment Variables

AUTOMATIC1111 can be customised using the following environment variables, these can be configured
by creating a file named `a1111.env` with one variable per line in the format `VARIABLE_NAME=VALUE`,
only variables being set need to be present in the file.

| Variable | Purpose | Example |
| -------- | ------- |---------|
| `API_AUTH` | Enables the API and sets up authentication credentials for it. | `app1:super_secret,app2:Sup3r_S3Cr3T` |
| `CPU` | Runs all functions on the CPU (very slow). Any value will enable this. | `1` |
| `CONSOLE_PROMPTS` | Enables logging of positive prompts to Docker logs. Any value will enable this | `on` |
| `CORS_ORIGINS` | Sets the permitted Cross-Origin Resource Sharing (CORS) domains, comma separated. | `*.example.com,*.example.net`| 
| `CUSTOM_CODE` | Allows custom code to run in the web UI. Any value will enable this. | `yes` |
| `LOG_LEVEL` | Sets the log level to one of: CRITICAL, ERROR, WARNING, INFO, DEBUG. Defaults to INFO. | `WARNING` |
| `NO_PROMPT_HISTORY` | Disables saving and loading of the last prompt. Any value will enable this. | `True` |
| `NO_WEB_UI` | If `API_AUTH` is also set, disables the web UI, exposing only the API. Any value will enable this. | `t` |
| `SERVER_NAME` | Sets the server hostname. | `sd.ai.example.com` |
| `UI_AUTH` | Sets user credentials for hte web UI. Same format as `API_AUTH` | `user1:super_secret,user2:Sup3r_S3Cr3T` |
| `UI_AUTH_FILE` | Points to a file containing web UI credentials. The file has the same format as `API_AUTH`. Mutually exclusive with `UI_AUTH` | `/run/secrets/ui_auth` |
| `XFORMERS` | Enables xformers for cross attention layers. Any value will enable this. | `y` |

### Volumes

The image uses one volume:

* `automatic1111` (mounted as `/data/`) for user-content such as models, uploads, output files ,etc.
