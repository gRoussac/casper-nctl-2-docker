FROM python:3-slim-bookworm as build

ARG BRANCH_NODE=release-1.5.6
ARG BRANCH_CLIENT=release-2.0.0
ARG BRANCH_SIDECAR

RUN apt-get update \
  && apt-get install -y \
  curl \
  build-essential \
  libssl-dev \
  libffi-dev \
  pkg-config \
  make \
  cmake \
  gcc \
  g++ \
  jq \
  git \
  wabt \
  && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="$PATH:/root/.cargo/bin"

SHELL ["/bin/bash", "--login", "-c"]

WORKDIR /app

RUN git clone -b $BRANCH_NODE https://github.com/casper-network/casper-node.git ;
RUN git clone -b $BRANCH_CLIENT https://github.com/casper-ecosystem/casper-client-rs.git ;
RUN git clone -b main https://github.com/casper-network/casper-node-launcher.git ;
RUN if [ -n "$BRANCH_SIDECAR" ]; then \
  git clone https://github.com/casper-network/casper-nctl.git ; \
  git clone -b $BRANCH_SIDECAR https://github.com/casper-network/casper-sidecar.git ; \
  fi

COPY sh/*.sh .

RUN chmod +x ./*.sh

ENV VIRTUAL_ENV=/app/casper-nctl/venv

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN ./setup.sh >> setup_output1.txt
RUN if [ -n "$BRANCH_SIDECAR" ]; then \
  ./compile.sh >> compile_output.txt; \
  else \
  ./compile.sh "/app/casper-node/utils/nctl" >> compile_output.txt; \
  fi
RUN ./clean-build-artifacts.sh >> clean-build-artifacts.txt
CMD ["/bin/bash", "-ci", "cat compile_output.txt"]

FROM python:3-slim-bookworm as run

RUN apt-get update \
  && apt-get install -y \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /app .

COPY sh/*.sh .

RUN chmod +x ./*.sh

RUN "./setup.sh" >> setup_output.txt

EXPOSE 11101-11105 14101-14105 18101-18105

CMD if [ -n "$BRANCH_SIDECAR" ]; then \
  ["/bin/bash", "-ci", "/app/restart.sh"] \
  else \
  ["/bin/bash", "-ci", "/app/restart.sh", "/app/casper-node/utils/nctl"] \
  fi

