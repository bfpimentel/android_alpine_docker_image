FROM openjdk:8-jdk-slim

ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools:$PATH
ENV SDK_TOOLS_VERSION 4333796
ENV SDK_VERSION 28
ENV BUILD_TOOLS_VERSION 28.0.3
ENV FIREBASE_HOME /opt/firebase

WORKDIR /opt

RUN apt-get update && \
    yes | apt-get install ruby && \
    apt-get install --no-install-recommends -y --allow-unauthenticated build-essential ruby-dev

RUN gem install bundler

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && apt-get clean

RUN apt-get update && \
    yes | apt-get install curl

RUN curl https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip -o android-sdk.zip && \
    unzip -o -qq android-sdk.zip -d android-sdk && rm android-sdk.zip && \
    yes | sdkmanager "platform-tools" && \
    yes | sdkmanager "platforms;android-${SDK_VERSION}" && \
    yes | sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" && \
    yes | sdkmanager "extras;android;m2repository" && \
    yes | sdkmanager "extras;google;m2repository" && \
    yes | sdkmanager --licenses