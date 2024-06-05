# Use the Ubuntu image with Python
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip tmux git curl

# Clone the dotfiles repository
RUN git clone https://github.com/ThiagoLira/.dotfiles /root/.dotfiles

# Set the working directory
WORKDIR /root/.dotfiles

# Run the installation scripts
RUN chmod +x install_neovim.sh install_stow.sh install_tmux_tpm.sh && \
    ./install_neovim.sh && \
    ./install_tmux_tpm.sh && \
    ./install_stow.sh

# Stow the configurations for nvim and tmux
RUN stow nvim && stow tmux

# Set default shell to bash and start tmux in the /fsx/thiago directory
CMD ["bash", "-c", "tmux new-session -c /fsx/thiago"]

# To use all GPUs from the host machine, use NVIDIA runtime (note: requires nvidia-docker2 to be installed)
# Docker run command should include --gpus all

