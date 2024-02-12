FROM node:18

RUN mkdir -p /app/node_modules && chown -R node:node /app

WORKDIR /app

COPY package*.json ./

USER node

RUN npm install --verbose
# If you are building your code for production
# RUN npm ci --omit=dev

# COPY . .

COPY --chown=node:node . .

EXPOSE 5000

CMD [ "node", "app.js" ]