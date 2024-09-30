# Use Ruby base image
FROM ruby:2.6.8

# Install essential dependencies
RUN apt-get update -qq && apt-get install -y \
    curl \
    gnupg \
    nodejs \
    npm

# Set up Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Install additional dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    sqlite3 \
    libsqlite3-dev 

RUN gem update --system 3.2.3

# Set environment variables
ENV RAILS_ENV=development
ENV NODE_OPTIONS=--openssl-legacy-provider
ENV ADMIN_EMAIL=admin@example.com
ENV ADMIN_PASSWORD=admin123

# Set working directory in the container
WORKDIR /app

# Copy the rest of the application code into the container
COPY . /app

RUN echo "gem 'rails_12factor'" >> Gemfile

# Install gems
RUN gem install bundler:2.4.22 && bundle install

# Precompile assets
RUN yarn install
RUN bundle exec rake assets:precompile

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server by default when the container starts
CMD ["rails", "server", "-b", "0.0.0.0"]
