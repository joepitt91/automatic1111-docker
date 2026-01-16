FROM docker.io/library/python:3.14-slim
RUN apt-get -yq update &&\
    apt-get -yq install bc curl gcc git libgl1 libglib2.0-bin libtcmalloc-minimal4 &&\
    apt-get -yq autoremove &&\
    apt-get -yq clean &&\
    pip3 install --upgrade --no-cache-dir --quiet pip setuptools
RUN adduser --system --home /opt/a1111 -uid 999 a1111 &&\
    chown -R a1111:nogroup /opt/a1111 &&\
    mkdir /data &&\
    chown -R a1111:nogroup /data
USER a1111
WORKDIR /opt
ARG A1111_VERSION=0.0.0
ENV A1111_VERSION=${A1111_VERSION}
RUN git clone --depth 1 --branch ${A1111_VERSION} https://github.com/AUTOMATIC1111/stable-diffusion-webui a1111
WORKDIR /opt/a1111
RUN pip3 install --upgrade --no-cache-dir --quiet --user --no-warn-script-location -r requirements_versions.txt &&\
    git config --global --add safe.directory /opt/a1111
COPY --chown=a1111:nogroup webui-user.sh /opt/a1111/webui-user.sh
RUN /opt/a1111/webui.sh --exit --reinstall-torch --reinstall-xformers --skip-torch-cuda-test
ENTRYPOINT [ "/opt/a1111/webui.sh" ]
EXPOSE 7860
VOLUME /data
HEALTHCHECK CMD ["sh", "-c", "curl -fk http://127.0.0.1:7860/ || exit 1"]
LABEL org.opencontainers.image.authors="joepitt91 via https://github.com/joepitt91/automatic1111-docker/issues"
LABEL org.opencontainers.image.base.name=docker.io/library/python:3.10-slim
LABEL org.opencontainers.image.description="AUTOMATIC1111 Stable Diffusion Web UI is an open source generative artificial intelligence program that allows users to generate images from a text prompt."
LABEL org.opencontainers.image.documentation=https://github.com/joepitt91/automatic1111-docker
LABEL org.opencontainers.image.licenses=GPL-3.0-only
LABEL org.opencontainers.image.source=https://github.com/joepitt91/automatic1111-docker
LABEL org.opencontainers.image.title="AUTOMATIC1111"
LABEL org.opencontainers.image.url=https://github.com/joepitt91/automatic1111-docker
LABEL org.opencontainers.image.version=${A1111_VERSION}
