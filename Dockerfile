FROM node:latest

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

ENV NODE_ENV production
RUN npm install

COPY . .

RUN npm run compile

EXPOSE 8000
CMD [ "npm", "start" ]
