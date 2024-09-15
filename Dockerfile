# Use NVIDIA CUDA 11.8 development image based on Ubuntu 20.04
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3.10 \
    python3.10-dev \
    python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# check the CUDA version of your hardware at https://developer.nvidia.com/cuda-gpus
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6"

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install PyTorch with CUDA 11.8 support and additional packages
RUN python3 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    python3 -m pip install llama-recipes fastcore "transformers!=4.38.*,!=4.39.*" --extra-index-url https://download.pytorch.org/whl/test/cu118

# Clone and install HQQ
RUN git clone https://github.com/mobiusml/hqq.git && \
    cd hqq && \
    pip install . && \
    cd hqq/kernels && \
    python3 setup_cuda.py install && \
    cd /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Install Jupyter
RUN python3 -m pip install jupyter

# Copy the rest of the application code
COPY . .

# Expose the port Jupyter will run on
EXPOSE 8888

# Set the command to run Jupyter when the container starts
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root",  "--NotebookApp.token=''", "--NotebookApp.password=''"]