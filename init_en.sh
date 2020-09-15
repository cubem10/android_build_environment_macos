#!/bin/zsh
# set the number of open files to be 1024
ulimit -S -n 1024
# Install Command Line Tools
echo "Installing Xcode Command Line Tools.."
xcode-select --install

# Install Homebrew
echo "Installing Homebrew.."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
export PATH=/usr/local/bin:$PATH

# Install build tools
echo "Installing git and gnupg2..."
brew install git gnupg2

# Cleanup check
echo -e "This progress removes file named 'android' or 'mount.sh' on this folder. Please move them to another folder. (y/n): "
read yn

# Begin
if [ ${yn} = 'y' ]; then
    # Cleanup
    rm android.*
    rm mount.sh
    # Disk Image Size
    echo -e "Please enter the size of disk image. ex) 4g: "
    read size
    echo "Disk Image Size: $size"
    # Create disk image
    hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size ${size} ./android.dmg
    # mount
    if [ $(ls android.dmg.sparseimage) = 'android.dmg.sparseimage' ]; then
        hdiutil attach ./android.dmg.sparseimage
        echo 'ulimit -S -n 1024 && hdiutil attach $(dirname $0)/android.dmg.sparseimage' >> ./mount.sh
    elif [ $(ls android.dmg) = 'android.dmg' ]; then
        hdiutil attach ./android.dmg.sparseimage
        echo 'ulimit -S -n 1024 && hdiutil attach $(dirname $0)/android.dmg.sparseimage' >> ./mount.sh
    else
        echo "ERROR: mount failed. Please report them on github issues."
    fi
    
    # mount.sh permission
    chmod +x ./mount.sh
    echo "When disk image unmounted, enter './mount.sh' to remount. \nPlease move to newly mounted disk and start building."
# When cleanup not allowed
else
    exit
fi
