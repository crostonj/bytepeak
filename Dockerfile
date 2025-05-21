# Stage 1: Build the React application
FROM node:lts-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
# This leverages Docker's cache. These files change less often than the source code.
COPY package*.json ./

# Install dependencies
# If you use yarn, replace 'npm install' with 'yarn install'
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application
# Replace 'npm run build' if your build script is different
RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:stable-alpine

# Copy the build output from the 'builder' stage to Nginx's web root directory
# The default build output for Create React App is 'build'. Adjust if yours is different (e.g., 'dist').
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]