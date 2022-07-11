# build stage
ARG ALPINE_VERSION=3.16
ARG REPO=718206584555.dkr.ecr.us-east-1.amazonaws.com

FROM ${REPO}/golang:1.17.11-alpine${ALPINE_VERSION} AS builder

ARG SRC=/build/
COPY . ${SRC}
WORKDIR ${SRC}

RUN go mod download && go mod verify
RUN go build -o /bin/image-of-day

# final stage
FROM ${REPO}/alpine:${ALPINE_VERSION}

COPY --from=builder /bin /bin
COPY --from=builder /build/templates templates

EXPOSE 80/tcp
CMD [ "image-of-day" ]