FROM cimg/android:2024.07-ndk

# RUN sdkmanager "ndk;26.1.10909125" "cmake;3.22.1"
# RUN sdkmanager "ndk;27.0.11902837" "cmake;3.22.1"
RUN sdkmanager "ndk;26.1.10909125" "cmake;3.22.1"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

RUN source "$HOME/.cargo/env"

ENV PATH="/home/circleci/.cargo/bin:${PATH}" 

RUN rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

RUN curl --proto '=https' --tlsv1.2 -LsSf https://github.com/1Password/typeshare/releases/download/v1.9.2/typeshare-cli-v1.9.2-installer.sh | sh

RUN cargo install cargo-ndk sccache

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - && \
    sudo apt-get install -y nodejs ccache && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

ENV HOME /home/circleci

RUN mkdir -p "$HOME/.npm" \
    && npm config set prefix "$HOME/.npm"
ENV PNPM_HOME="$HOME/.pnpm"
ENV PATH="${PNPM_HOME}:$HOME/.npm/bin:${PATH}"

RUN echo $PATH

# Enable Corepack to manage package managers
RUN sudo corepack enable

# Install PNPM using Corepack
RUN sudo corepack prepare pnpm@latest --activate

RUN npm install @openapitools/openapi-generator-cli -g
RUN openapi-generator-cli version
