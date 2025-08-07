# Base image with Node.js
FROM node:18-slim

# Install OpenJDK 8
RUN apt-get update && apt-get install -y wget gpg python3 make g++ && mkdir -p /etc/apt/keyrings && wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc && echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print $2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && apt-get update && apt-get install -y temurin-8-jdk && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory to /app
WORKDIR /app

# Copy all project files into /app
COPY . .

# Change working directory to /app/server
WORKDIR /app/server

# Install PM2 globally
RUN npm install -g pm2

# Set Python Location
ENV PYTHON=/usr/bin/python3

# Install project dependencies inside /app/server
RUN npm install

# Expose your app port (change if different)
EXPOSE 22533
EXPOSE 22222

# Start the app with PM2 from /app/server
CMD ["pm2-runtime","index.js"]
