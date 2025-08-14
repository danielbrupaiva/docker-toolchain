# Docker toolchain
This is a docker base repository for toolchain's creation to be use in embedded software developement

## Repository Description
This repository provides a Docker-based environment for building and managing toolchains tailored for embedded software development. It simplifies the setup process, ensuring consistency and reproducibility across different development systems.

## Features

- Pre-configured Docker images for toolchain creation
- Integrated sysroot support for BeaglePlay and Raspberry Pi 4 boards
- Easy setup and teardown of development environments
- Support for multiple embedded platforms
- Automated build and deployment scripts
- Isolation of dependencies for reliable builds
- Example commands for common development tasks

## How to cross compile using the Docker image

To cross compile your embedded software for aarch64 using CMake and a toolchain file with the Docker toolchain image, follow these steps:

1. Place your source code in a directory accessible to Docker (for example, in a `src` folder inside the repository).

2. Ensure you have a CMake toolchain file for aarch64 (e.g., `aarch64-toolchain.cmake`) in your project directory.

3. Start the Docker container with your source directory mounted:
    ```bash
    docker run -it --rm -v $(pwd)/src:/workspace/src toolchain:latest
    ```

4. Inside the container, create a build directory and configure your project with CMake using the toolchain file:
    ```bash
    cd /workspace/src
    mkdir build && cd build
    cmake .. -DCMAKE_TOOLCHAIN_FILE=../aarch64-toolchain.cmake
    ```

5. Build your project:
    ```bash
    cmake --build .
    ```

6. The resulting binaries will be available in your local `src/build` directory after compilation.

**Tip:** Customize your toolchain file and CMake options to match your target aarch64 platform and project requirements.

## How to build docker toolchain

To build the Docker toolchain environment, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/docker-toolchain.git
    cd docker-toolchain
    ```

2. Build the Docker image:
    ```bash
    docker build -t toolchain:latest .
    ```

3. Start the development environment using Docker Compose:
    To start the development environment with custom environment variables using an env file, use:

    ```bash
    docker compose --env-file .env up -d --build
    ```

    Create a `.env` file in the repository root and define your variables, for example:

    ```
    MY_CUSTOM_VAR=value
    ANOTHER_VAR=example
    ```

4. Access the running container:
    ```bash
    docker exec -it toolchain bash
    ```
5. (Optional) To register and push your Docker image to a registry:

    - Log in to your Docker registry (e.g., Docker Hub):
    ```bash
    docker login
    ```

    - Tag your image for the registry:
    ```bash
    docker tag toolchain:latest yourusername/toolchain:latest
    ```

    - Push the image:
    ```bash
    docker push yourusername/toolchain:latest
    ```   

Refer to the **Useful commands** section below for additional operations.

**Others useful commands**

```bash
docker system prune -a --volumes
docker compose up -d --build
docker compose up -d --build --force-recreate
docker exec -it toolchain bash
docker build -t toolchain:v0.3 -f D
ockerfile .
```
