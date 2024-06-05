# Build the Docker image
docker build -t dev-environment .

# Run the Docker container with GPU support and directory mapping
docker run --gpus all -it -v /fsx:/fsx dev-environment
