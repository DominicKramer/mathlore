FROM alpine

# the version of the mlg executable to use
ARG MLG_VERSION=0.20.0

# the commit SHA in https://github.com/mathlingua/mathlore-content
# of the content to use
ARG MATHLORE_SHA=384baf049df2d6967c05ca32c124c8ba483bd7b8

WORKDIR /app

# download and extract the Mathlore content
RUN wget https://github.com/mathlingua/mathlore-content/archive/${MATHLORE_SHA}.zip
RUN unzip ${MATHLORE_SHA}.zip

# the mathlore-content-${MATHLORE_SHA} directory needs to be renamed to mathlore-content
# because the MATHLORE_SHA variable is available at build time but not run time
RUN mv mathlore-content-${MATHLORE_SHA} mathlore-content
WORKDIR mathlore-content

# download mlg with the correct architecture
# (this assumes the container will always be 64 bit)
RUN ARCH=$([[ "$(uname -m)" == "aarch64" ]] && echo "arm64" || echo "amd64") && \
    wget https://github.com/mathlingua/mathlingua/releases/download/v${MLG_VERSION}/mlg-${MLG_VERSION}-linux-${ARCH} -O mlg
RUN chmod +x ./mlg

# start the server
CMD cd /app/mathlore-content && ./mlg view
