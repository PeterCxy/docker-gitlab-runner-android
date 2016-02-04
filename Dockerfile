# Dockerfile for gitlab-runner
# Android envirionment
# Based on ArchLinux
FROM base/archlinux:2015.06.01

# Enable multilib
RUN echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Use Rackspace's mirror
RUN echo -e 'Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch\nServer = http://mirrors.kernel.org/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# Do an update
RUN pacman -Syyu --noconfirm

# Install build dependencies
RUN pacman -S --noconfirm base-devel git gradle

# Hack the sudo command
RUN echo 'nobody ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install gitlab-runner
WORKDIR /tmp/builder
RUN git clone https://aur.archlinux.org/go-bindata.git && \
  chomod -R 777 go-bindata && \
  cd go-bindata && sudo -u nobody makepkg -sci --noconfirm
RUN git clone https://aur.archlinux.org/gitlab-ci-multi-runner.git && \
  chmod -R 777 gitlab-ci-multi-runner && \
  cd gitlab-ci-multi-runner && sudo -u nobody makepkg -sci --noconfirm

# Install Android SDK components
RUN git clone https://aur.archlinux.org/android-sdk.git && \
  chmod -R 777 android-sdk && \
  cd android-sdk && sudo -u nobody makepkg -sci --noconfirm

# Install Android repositories
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | \
  android update sdk --no-ui --filter android-21,android-22,android-23,build-tools-23.0.2,extra-android-m2repository-25

# Uninstall sudo for security and clean up the directory
RUN pacman -R --noconfirm sudo
RUN rm -rf /tmp/builder/*

# Change WORKDIR and install the script
WORKDIR /usr/local
COPY run.sh /usr/local
RUN chmod +x run.sh

# Finished!
CMD ['./run.sh']
