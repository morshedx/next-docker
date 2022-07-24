# Base on offical Node.js Alpine image
FROM node:lts-alpine

# Setting environment variable as production.
ENV NODE_ENV production
ENV NPM_CONFIG_LOGLEVEL warn

# Set working directory
WORKDIR /usr/app

# Install PM2 globally
RUN npm install --global pm2

# Copy package.json and package-lock.json before other files
# Utilise Docker cache to save re-installing dependencies if unchanged
COPY ./package*.json ./

# Install dependencies
RUN npm install --production
RUN npm i next-swc-linux-x64-gnu @swc/core-linux-x64-gnu @next/swc-linux-x64-musl

# Copy all files
COPY ./ ./

# Build app
RUN npm run build

# Expose the listening port
EXPOSE 3000

# Run container as non-root (unprivileged) user
# The node user is provided in the Node.js Alpine base image
USER node

# Run npm start script with PM2 when container starts
CMD [ "pm2-runtime", "npm", "--", "start" ]