FROM node:12 as builder
WORKDIR /app

COPY . .

RUN npm install --production
RUN cp -r node_modules/ /tmp/prod_modules/

RUN npm install
ENV NODE_ENV production

RUN npx blitz build

FROM node:slim as prod
WORKDIR /app
RUN apt-get -qy update && apt-get -qy install openssl
COPY --from=builder /app/.blitz ./.blitz
COPY --from=builder /tmp/prod_modules/ ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package.json ./

ENV PORT 3000
EXPOSE 3000

CMD npx blitz start --production