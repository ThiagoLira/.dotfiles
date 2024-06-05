# Use the Ubuntu image with Python
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip tmux git curl sudo

# Create a new user and grant sudo privileges
RUN useradd -m thiago && echo "thiago:password" | chpasswd && usermod -aG sudo thiago

# Switch to the new user
USER thiago
WORKDIR /home/thiago

# Clone the dotfiles repository
RUN git clone https://github.com/ThiagoLira/.dotfiles /home/thiago/.dotfiles

# Set the working directory
WORKDIR /home/thiago/.dotfiles

# Install Neovim using the provided script
RUN chmod +x install_neovim.sh install_stow.sh install_tmux_tpm.sh && \
    ./install_neovim.sh && \
    ./install_tmux_tpm.sh && \
    ./install_stow.sh

# Stow the configurations for nvim and tmux
RUN stow nvim && stow tmux

# Set default shell to bash and start tmux in some dir 
CMD ["bash", "-c", "tmux new-session -c /home/thiago"]

# To use all GPUs from the host machine, use NVIDIA runtime (note: requires nvidia-docker2 to be installed)
# Docker run command should include --gpus all

