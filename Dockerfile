# Use an official Ruby runtime as a parent image
FROM ruby:3.2

# Set environment variables to ensure output is sent straight to the terminal without buffering it first,
# and set the path where the Ruby application will reside
ENV RUBYOPT -Eutf-8
ENV BUNDLE_PATH /gems

# Copy the Gemfile and Gemfile.lock into the image
COPY ./Gemfile* /tmp/
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 --gemfile=/tmp/Gemfile

# Add the application code to the image
ADD ./src /app/code

# Set the working directory inside the image
WORKDIR /app/code
