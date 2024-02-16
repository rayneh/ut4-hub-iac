# Use the official Debian slim image
FROM debian:stable-slim

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-client ansible && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create an ansible user
RUN useradd -m -d /home/ansible ansible

# Set up SSH for the ansible user
RUN mkdir /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    chown ansible:ansible /home/ansible/.ssh

# Switch to the ansible user
USER ansible

# Start as ansible user
CMD ["/bin/bash"]
