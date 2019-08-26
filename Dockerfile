FROM node:12-alpine

RUN mkdir -p /opt && mkdir -p /opt/ignitialio

ADD . /opt/ignitialio

WORKDIR /opt/ignitialio

RUN npm install && npm run client:build

CMD ["node", "./server/index.js"]
