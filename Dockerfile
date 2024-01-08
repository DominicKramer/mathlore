# use the x86-64 platform since the x86-64 version of Node.js is used
FROM --platform=linux/amd64 golang:1.20

# install unzip and xz-utils so that the downloaded content can be extracted
RUN apt-get update && apt-get install unzip xz-utils

##################################### install Node.js ##############################################
WORKDIR /app

RUN wget https://nodejs.org/dist/v18.16.0/node-v18.16.0-linux-x64.tar.xz
RUN tar -xf node-v18.16.0-linux-x64.tar.xz

ENV PATH="${PATH}:/app/node-v18.16.0-linux-x64/bin"

######################################### install yarn #############################################

RUN npm install --global yarn

########################################## install mlg #############################################

WORKDIR /app

# the commit SHA in https://github.com/mathlingua/mathlingua to use
ARG MATHLINGUA_SHA=15e9f6593661d8d6dd649113a2e896a6e6da81ea

RUN wget https://github.com/mathlingua/mathlingua/archive/${MATHLINGUA_SHA}.zip
RUN unzip ${MATHLINGUA_SHA}.zip

RUN mv mathlingua-${MATHLINGUA_SHA} mathlingua
WORKDIR /app/mathlingua/web

# install the UI dependencies
RUN yarn install

WORKDIR /app/mathlingua
RUN make all

RUN chmod +x ./bin/mlg

ENV PATH="${PATH}:/app/mathlingua/bin"

################################### download the Mathlore content ##################################

WORKDIR /app

# the commit SHA in https://github.com/mathlingua/mathlore-content
# of the content to use
ARG MATHLORE_SHA=97760e194ebcb636613b128036f411c79f51b256

# download and extract the Mathlore content
RUN wget https://github.com/mathlingua/mathlore-content/archive/${MATHLORE_SHA}.zip
RUN unzip ${MATHLORE_SHA}.zip

# the mathlore-content-${MATHLORE_SHA} directory needs to be renamed to mathlore-content
# because the MATHLORE_SHA variable is available at build time but not run time
RUN mv mathlore-content-${MATHLORE_SHA} mathlore-content

####################################################################################################

WORKDIR /app/mathlore-content

# start the server
CMD cd /app/mathlore-content && mlg view
