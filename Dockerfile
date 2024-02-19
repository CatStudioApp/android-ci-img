FROM cimg/android:2024.01-ndk

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

RUN source "$HOME/.cargo/env"

ENV PATH="/home/circleci/.cargo/bin:${PATH}" 

RUN rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

RUN cargo install typeshare-cli cargo-ndk
