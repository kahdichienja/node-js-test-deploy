FROM node:18-slim
WORKDIR /app
COPY package*.json yarn.lock ./
RUN yarn install --production
COPY . .
EXPOSE 3000
CMD ["yarn", "start"]
