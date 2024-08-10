#!/bin/bash

# Function to prompt for installation
install_prompt() {
    read -p "\nDo you want to install $1? (yes/no): " choice
    if [[ "$choice" == "yes" || "$choice" == "y" ]]; then
        eval "$2"
    else
        echo "$1 installation skipped."
    fi
}

# Update and upgrade packages
echo "********************************************************"
echo "     Updating and upgrading packages"
echo "********************************************************"
sudo apt update
sudo apt dist-upgrade -y

# Install ZSH
install_prompt "ZSH" "sudo apt install -y zsh"

# Install essential system packages
install_prompt "Essential System Packages" "sudo apt-get -y install build-essential pkg-config libssl-dev"

# Setup git / ssh for user
echo "********************************************************"
echo "     Configuring Git to use SSH to sign Commits "
echo "********************************************************"
read -p "Enter your GitHub/Gitlab username: " username
git config --global user.name "$username"

read -p "Enter your GitHub/Gitlab email: " email
if git config --global user.email "$email"; then
    cd ~/.ssh
    ssh-keygen -t ed25519 -C "$email"

    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "Please follow these steps"
    echo "1. Copy the following text output: "
    echo " "
    cat ~/.ssh/id_ed25519.pub
    echo " "
    echo "2. Go to your GitHub/Gitlab account settings/preference respectively."
    echo "2a. Click on SSH and GPG keys(Github) or SSH Keys(Gitlab)."
    echo "2b. Click on New SSH key."
    echo "2c. In the 'Title' field, add a descriptive label for the new key."
    echo "2d. In the 'Key' field, paste your public key. Hit 'Add SSH key'(for github), 'Add key' (for gitlab)."
    echo "If prompted, confirm access to your GitHub/Gitlab account."
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
    echo "We need your GitHub/Gitlab email to continue!"
    echo "###########################################"
    echo "Setting up Git for this user ABORTED"
    echo "###########################################"
fi

# Install nvm
install_prompt "nvm" "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && source ~/.bashrc && nvm --version"

# Install Docker
install_prompt "Docker" "sudo apt install -y docker.io && sudo usermod -aG docker \$USER"

# Install Docker Compose (if Docker is installed)
if command -v docker &> /dev/null; then
    install_prompt "Docker Compose" "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-\$(uname -s)-\$(uname -m)\" -o /usr/local/bin/docker-compose && \
    sudo chmod +x /usr/local/bin/docker-compose && docker-compose --version"
fi

# Install Java
install_prompt "OpenJDK 17" "sudo apt install -y openjdk-17-jdk && sudo update-alternatives --config java"

# Set JAVA_HOME
read -p "Do you want to set JAVA_HOME? (yes/no): " set_java_home
if [[ "$set_java_home" == "yes" || "$set_java_home" == "y" ]]; then
    echo "Please copy the path from the previous command output (exclude ../bin/java)."
    read -p "Enter the path: " java_path
    echo "JAVA_HOME=\"$java_path\"" | sudo tee -a /etc/environment
    source /etc/environment
    echo "JAVA_HOME set to $JAVA_HOME"
fi

# Install Maven
install_prompt "Maven" "sudo apt install -y maven"

# Install Asciidoctor
install_prompt "Asciidoctor" "sudo apt-get install -y asciidoctor"

# Install PlantUML
install_prompt "PlantUML" "sudo apt-get install -y plantuml"

# Install PostgreSQL
install_prompt "PostgreSQL" "sudo apt install postgresql"

# Install Angular globally
install_prompt "Angular" "npm install -g @angular/cli"

# Install Rust
install_prompt "Rust" "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

# Install Google Chrome
install_prompt "Google Chrome" "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
sudo dpkg -i google-chrome-stable_current_amd64.deb && \
sudo apt-get install -f -y && \
google-chrome --version"

# Install ChromeDriver
install_prompt "ChromeDriver" "wget https://chromedriver.storage.googleapis.com/92.0.4515.107/chromedriver_linux64.zip && \
unzip chromedriver_linux64.zip && \
sudo mv chromedriver /usr/bin/chromedriver && \
sudo chown root:root /usr/bin/chromedriver && \
sudo chmod +x /usr/bin/chromedriver && \
chromedriver --url-base=/wd/hub"

echo "\nThe next program will change the shell session if you enter 'yes' or 'y'.\nWhen the session changes enter 'exit' to complete the running of this script"

# Install Oh-my-zsh
install_prompt "Oh-my-zsh" "(sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" && \
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting) || echo 'Oh-my-zsh installation failed'"


echo "********************************************************"
echo "     Done!!! "
echo "********************************************************"
