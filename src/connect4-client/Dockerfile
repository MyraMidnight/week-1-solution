# First we want to build on an image the includes the environment we need to build and run our code, we can use 'node:16-alpine':
FROM node:16-alpine

# Now set the working directory to /app:
WORKDIR /app

# Next we need to install all app dependencies,
# First copy both package.json and package-lock.json into the current working directory:
COPY package.json package.json
COPY package-lock.json package-lock.json
# Then run npm install --production
RUN npm install --production

# Now we need the rest of our application code, copy your entire folder into the image working directory:
COPY . .

# Lastly we need to run the application when the container starts, set the command as npm start:
CMD [ "npm", "start" ]