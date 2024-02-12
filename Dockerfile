FROM node:20-alpine

# RUN mkdir -p /app/node_modules && chown -R node:node /app

WORKDIR /app

COPY package*.json ./

# USER node

# RUN npm config set registry https://registry.npmjs.org/

RUN npm i
# If you are building your code for production
# RUN npm ci --omit=dev

COPY . .

# COPY --chown=node:node . .

EXPOSE 5000

CMD [ "node", "app.js" ]