FROM golang:1.13.1-buster as golang

FROM jupyter/minimal-notebook

LABEL maintainer="rusa <rusa.gedougawa@gmail.com>"

USER root

RUN apt-get -y update
RUN apt-get -y install libzmq3-dev pkg-config

ENV GO_VERSION=1.13.1 \
    GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

COPY --from=golang /usr/local/go/ /usr/local/go/

RUN go get -u github.com/gopherdata/gophernotes && \
    mkdir -p /home/jovyan/.local/share/jupyter/kernels/gophernotes && \
    chown -R jovyan /home/jovyan/.local && \
    cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* /home/jovyan/.local/share/jupyter/kernels/gophernotes

EXPOSE 8888

USER jovyan

CMD ["jupyter", "lab", "--allow-root"]
