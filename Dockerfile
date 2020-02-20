FROM golang:1.13.1-buster as golang

FROM jupyter/minimal-notebook

LABEL maintainer="rusa <rusa.gedougawa@gmail.com>"

USER root

# All
RUN apt-get -y update

# Bash
RUN pip install bash_kernel
RUN python -m bash_kernel.install

# Golang
RUN apt-get -y install libzmq3-dev pkg-config

ENV GO_VERSION=1.13.1 \
    GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

COPY --from=golang /usr/local/go/ /usr/local/go/

RUN go get -u github.com/gopherdata/gophernotes && \
    mkdir -p /home/jovyan/.local/share/jupyter/kernels/gophernotes && \
    chown -R jovyan /home/jovyan/.local && \
    cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* /home/jovyan/.local/share/jupyter/kernels/gophernotes

RUN echo 'Defaults visiblepw'             >> /etc/sudoers
RUN echo 'jovyan ALL=(ALL) NOPASSWD:ALL'  >> /etc/sudoers

EXPOSE 8888

USER jovyan

CMD ["jupyter", "lab", "--allow-root"]
