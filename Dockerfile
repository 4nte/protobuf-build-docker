FROM memominsk/protobuf-alpine

RUN set -ex && apk --update --no-cache add \
    bash \
    protobuf \
    protobuf-dev \
    curl \
    git \
    nodejs \
    nodejs-npm \
    make \
    musl-dev \
    go

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

ARG protoc_gen_grpc_java_version=1.28.0

WORKDIR /tmp

# Install protoc-gen-grpc-java plugin (protoc --grpc-java_out)
RUN curl -L  https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${protoc_gen_grpc_java_version}/protoc-gen-grpc-java-${protoc_gen_grpc_java_version}-linux-x86_64.exe -o protoc-gen-grpc-java
RUN chmod a+x protoc-gen-grpc-java && mv protoc-gen-grpc-java /bin/protoc-gen-grpc-java

# Install protoc-gen-ts plugin required (protoc --ts_out)
RUN npm i -g ts-protoc-gen@0.12.0 typescript@3.8.3

# Install protoc-gen-go
RUN go get -u github.com/golang/protobuf/protoc-gen-go

# Install protoc-gen-validate
RUN go get -d github.com/envoyproxy/protoc-gen-validate
RUN cd $GOPATH/src/github.com/envoyproxy/protoc-gen-validate && make build

ENTRYPOINT /bin/sh