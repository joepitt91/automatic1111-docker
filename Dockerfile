FROM docker.io/library/python:3.13-slim
RUN apt-get -yq update &&\
    apt-get -yq install bc curl git libgl1 libglib2.0-bin libtcmalloc-minimal4 &&\
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
RUN git clone --depth 1 --branch ${A1111_VERSION} https://github.com/AUTOMATIC1111/stable-diffusion-webui a1111
COPY --chown=a1111:a1111 webui-user.sh /opt/a1111/webui-user.sh
WORKDIR /opt/a1111
RUN pip3 install --upgrade --no-cache-dir --quiet --user --no-warn-script-location -r requirements_versions.txt &&\
    pip3 install --upgrade --no-cache-dir --quiet --user --no-warn-script-location torch torchvision torchaudio &&\
    pip3 install --upgrade --no-cache-dir --quiet --user --no-warn-script-location xformers --index-url https://download.pytorch.org/whl/cu124 &&\
    git config --global --add safe.directory /opt/a1111 &&\
    python -c 'from modules import launch_utils; launch_utils.args.skip_torch_cuda_test=True; launch_utils.prepare_environment()'
ENTRYPOINT [ "/opt/a1111/webui.sh" ]
EXPOSE 7860
VOLUME /data
HEALTHCHECK CMD ["sh", "-c", "curl -fk http://127.0.0.1:7860/ || exit 1"]
