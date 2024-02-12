# FROM node:20-alpine

# # RUN mkdir -p /app/node_modules && chown -R node:node /app

# WORKDIR /app

# COPY package*.json ./

# # USER node

# # RUN npm config set registry https://registry.npmjs.org/

# RUN npm i
# # If you are building your code for production
# # RUN npm ci --omit=dev

# COPY . .

# # COPY --chown=node:node . .

# EXPOSE 5000

# CMD [ "node", "app.js" ]


# Use a slim Node.js image
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Stage for production
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy built files from the previous stage
COPY --from=builder /app .

# Expose port
EXPOSE 5000

# Command to run the application
CMD [ "node", "app.js" ]
