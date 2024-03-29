FROM cimg/android:2024.01-ndk

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

RUN source "$HOME/.cargo/env"

ENV PATH="/home/circleci/.cargo/bin:${PATH}" 

RUN rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

RUN cargo install typeshare-cli cargo-ndk sccache

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - && \
    sudo apt-get install -y nodejs && \
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
