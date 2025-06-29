FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=optional
COPY . .
CMD ["npm", "start"]
