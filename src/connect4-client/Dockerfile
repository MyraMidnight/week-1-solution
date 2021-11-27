FROM node:alpine

WORKDIR /app

COPY .pnp.cjs .pnp.loader.mjs .yarnrc.yml package.json yarn.lock ./
COPY .yarn .yarn

RUN yarn

COPY . .
RUN yarn build

CMD yarn start
