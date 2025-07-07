    # Use the pre-built SatDump Docker image
    FROM rpatel3001/docker-satdump:latest

    # Copy the run script into the container
    COPY run.sh /run.sh

    # Make the run script executable
    RUN chmod +x /run.sh

    # Set the entrypoint to our run script
    ENTRYPOINT ["/run.sh"]
    
