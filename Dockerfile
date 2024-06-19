# Use the Ubuntu image with Python
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip tmux git curl sudo wget

RUN touch /root/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install --lts

COPY . /root/.dotfiles

# Set the working directory
WORKDIR /root/.dotfiles

# Install Neovim using the provided script
RUN chmod +x install_neovim.sh install_tmux_tpm.sh install_stow.sh
RUN ./install_neovim.sh
RUN ./install_stow.sh
RUN ./install_tmux_tpm.sh

# Stow the configurations for nvim and tmux
RUN stow nvim && stow tmux

# update nvim and tmux plugins
RUN nvim --headless "+Lazy! sync" +qa
RUN /root/.tmux/plugins/tpm/scripts/install_plugins.sh

# Set default shell to bash and start tmux in some dir
CMD ["bash", "-c", "tmux new-session -c /root/"]

# To use all GPUs from the host machine, use NVIDIA runtime (note: requires nvidia-docker2 to be installed)
# Docker run command should include --gpus all
