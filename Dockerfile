FROM node:18-alpine as development

WORKDIR /usr/src/app

COPY package*.json .

RUN npm install

COPY . .

RUN npx prisma generate

RUN npm run build


FROM node:18-alpine as production

WORKDIR /usr/src/app

COPY package*.json .

COPY ./prisma prisma

RUN npm ci --only-production

COPY --from=development /usr/src/app/dist ./dist

CMD [ "node", "dist/index.js" ]
