#!/bin/bash

# Update and upgrade packages
echo "********************************************************"
echo "     Updating and upgrading packages"
echo "********************************************************"
sudo apt update
sudo apt dist-upgrade -y

# Install ZSH
echo "********************************************************"
echo "     INSTALLING ZSH "
echo "********************************************************"
sudo apt install -y zsh

# Install Oh-my-zsh
echo "********************************************************"
echo "     INSTALLING Oh-my-zsh "
echo "********************************************************"
if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    # Add autosuggestions
    echo "Configuring autosuggestions zsh"
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

    # Add syntax-highlighting
    echo "Configuring syntax-highlighting zsh"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Setup git / ssh for user.
echo "********************************************************"
echo "     Configuring Git to use SSH to sign Commits "
echo "********************************************************"
read -p "Enter your GitHub username: " username
git config --global user.name "$username"

read -p "Enter your GitHub email: " email
if git config --global user.email "$email"; then
    cd ~/.ssh
    ssh-keygen -t ed25519 -C "$email"

    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "Please follow these steps"
    echo "1. Copy the following text output: "
    echo " "
    cat ~/.ssh/id_ed25519.pub
    echo " "
    echo "2. Go to your GitHub account settings."
    echo "2a. Click on SSH and GPG keys."
    echo "2b. Click on New SSH key."
    echo "2c. In the 'Title' field, add a descriptive label for the new key."
    echo "2d. In the 'Key' field, paste your public key. Hit 'Add SSH key'."
    echo "If prompted, confirm access to your GitHub account."
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

    read -p "Have you completed these steps? (yes/no): " completed
    if [[ "$completed" == "yes" || "$completed" == "y" ]]; then
        git config --global gpg.format ssh
        git config --global user.signingkey ~/.ssh/id_ed25519.pub
        echo "You can now sign commits."
        echo " e.g  git commit -S -m 'commit message' "
    else
        echo "Run the script again to configure SSH for signing commits."
    fi

else
    echo "We need your GitHub email to continue!"
    echo "###########################################"
    echo "Setting up Git for this user ABORTED"
    echo "###########################################"
fi

# Install nvm
echo "********************************************************"
echo "     INSTALLING nvm "
echo "********************************************************"
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source ~/.bashrc  # Adjust for your shell configuration
    nvm --version
else
    echo "nvm is already installed."
fi

# Install Docker
echo "********************************************************"
echo "     INSTALLING Docker "
echo "********************************************************"
if ! command -v docker &> /dev/null; then
    sudo apt install -y docker.io
    if [ $? -eq 0 ]; then
        echo "Docker installation successful."
        sudo usermod -aG docker $USER 
        echo "Added $USER to docker group."
    else
        echo "Failed to install Docker."
    fi
else
    echo "Docker is already installed."
fi

# Install Docker Compose (if Docker is installed)
if command -v docker &> /dev/null; then
    echo "********************************************************"
    echo "     INSTALLING Docker Compose "
    echo "********************************************************"
    if ! command -v docker-compose &> /dev/null; then
        # Ensure /usr/local/bin exists
        sudo mkdir -p /usr/local/bin
        # Download and install Docker Compose
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        docker-compose --version
    else
        echo "Docker Compose is already installed."
    fi
fi

echo "********************************************************"
echo "     Done!!! "
echo "********************************************************"
