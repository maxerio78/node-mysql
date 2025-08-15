# Use the official Node.js image as a base
FROM public.ecr.aws/docker/library/node:18-alpine

# Set the working directory inside the container
WORKDIR /node-mysql/nodejs-mysql-crud/server.js

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the application source code into the container
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Define the command to run your application
CMD ["npm", "start"]
