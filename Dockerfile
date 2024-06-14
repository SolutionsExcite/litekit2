# Use the official Ubuntu 22.04 image and install necessary dependencies
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Python 3.10
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential wget nano cmake ninja-build \
    python3 python3-venv python3-dev python3-pip \
    python3-opencv python3-numpy x11-apps \
    libopencv-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools \
    gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 gstreamer1.0-pulseaudio \
    ffmpeg \
    libjpeg-dev libpng-dev libtiff-dev libwebp-dev \
    libgtk-3-dev libcanberra-gtk3-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libxine2-dev \
    libv4l-dev v4l-utils \
    libtbb-dev libeigen3-dev \
    libblas-dev liblapack-dev \
    mesa-common-dev libglu1-mesa-dev \
    libopenblas-dev \
    liblapacke-dev \
    libgphoto2-dev \
    libhdf5-dev \
    libprotobuf-dev protobuf-compiler \
    libtesseract-dev \
    openexr libopenexr-dev \
    libgflags-dev libgoogle-glog-dev \
    libjpeg8-dev zlib1g-dev libbz2-dev libtiff5-dev \
    libatlas-base-dev liblapack-dev liblapacke-dev libtbb-dev \
    libblas-dev \
    libgtk-3-dev

# Create work directory
WORKDIR /src/app

# Copy the application files
COPY . /src/app

# Create a Python 3.10 virtual environment with access to system-wide packages
RUN python3 -m venv /src/app/venv --system-site-packages

# Activate the virtual environment and upgrade pip
RUN /bin/bash -c "source /src/app/venv/bin/activate && pip install --upgrade pip"

# Download and install the RKNN toolkit in the virtual environment
RUN /bin/bash -c "source /src/app/venv/bin/activate && \
    wget https://raw.githubusercontent.com/airockchip/rknn-toolkit2/v2.0.0-beta0/rknn-toolkit-lite2/packages/rknn_toolkit_lite2-2.0.0b0-cp310-cp310-linux_aarch64.whl && \
    pip install rknn_toolkit_lite2-2.0.0b0-cp310-cp310-linux_aarch64.whl"

# Add shared libs for rknn toolkit lite2
RUN wget https://raw.githubusercontent.com/airockchip/rknn-toolkit2/master/rknpu2/runtime/Linux/librknn_api/aarch64/librknnrt.so \
    && mv librknnrt.so /usr/lib/librknnrt.so \
    && wget https://raw.githubusercontent.com/rockchip-linux/rknpu2/master/runtime/RK3588/Linux/librknn_api/aarch64/librknn_api.so \
    && mv librknn_api.so /usr/lib/librknn_api.so

# Test out simple premade example provided by rockchip to verify working install
WORKDIR /src/resnet18
RUN wget https://raw.githubusercontent.com/airockchip/rknn-toolkit2/master/rknn-toolkit-lite2/examples/resnet18/resnet18_for_rk3588.rknn \
    && wget https://github.com/airockchip/rknn-toolkit2/blob/master/rknn-toolkit-lite2/examples/resnet18/space_shuttle_224.jpg?raw=true \
    && mv space_shuttle_224.jpg?raw=true space_shuttle_224.jpg \
    && wget https://raw.githubusercontent.com/airockchip/rknn-toolkit2/master/rknn-toolkit-lite2/examples/resnet18/synset_label.py \
    && wget https://raw.githubusercontent.com/airockchip/rknn-toolkit2/master/rknn-toolkit-lite2/examples/resnet18/test.py

# Set the virtual environment as the default Python environment
ENV VIRTUAL_ENV=/src/app/venv
ENV PATH="/src/app/venv/bin:$PATH"

COPY verify_litekit2.sh verify_litekit2.sh

# Set execute permissions on the script
RUN chmod +x verify_litekit2.sh

# Entry point
CMD ["./verify_litekit2.sh"]