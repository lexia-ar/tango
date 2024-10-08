# Tango 70-b Design Document

## 1. Introduction

### Project Overview
Project Tango 70-b aims to develop and train the first large language model (LLM) specifically designed for and by Latin Americans, with a focus on Spanish language content. This ambitious project seeks to democratize AI technology in the region by leveraging consumer-grade hardware and innovative training techniques.

Key aspects of the project include:

1. Training a 70 billion parameter LLM using consumer GPUs (2x NVIDIA RTX 3090).
2. Implementing advanced techniques such as QLoRA, FSDP, and Half Quadratic Quantization to enable efficient training on limited hardware.
3. Utilizing Latin American-focused datasets, including Wikipedia content, literature, and historical and legal documents.
4. Exploring the economic and geopolitical implications of locally developed and hosted AI infrastructure in Latin America.
5. Documenting and open-sourcing the entire process to foster AI development in the region.
6. Investigating future possibilities for decentralized AI serving and smartphone-based AI applications in Latin America.

This project not only aims to create a powerful language model but also to spark discussions about AI sovereignty, economic feasibility, and the potential for Latin America to become a significant player in the global AI landscape. By combining technical innovation with strategic foresight, Tango 70-b seeks to position Argentina and Latin America at the forefront of AI development and application.

### Goals and Objectives
- Create a Proof of Concept for training highly capable AI on consumer GPUs, defined as an LLM that achieves an MMLU (or other metric) higher than X.
- Serve the first AI in Argentina at a cost proportional to local salary ranges/GDP per capita/minimum wage.
- Assess the economics of training, hosting, and serving LLMs from and for Latin America.
- Gain hands-on experience in training sota LLMs.
- Kickstart the discussion on the importance of training and serving AI in Latin America, including social, economic, and geopolitical aspects.
- Cement the AI scene in Argentina and Latin America.
- Position Argentina as the 4th AI pole globally.

### Scope of the Project
- Focus on Spanish language and Latin American content.
- Utilize consumer-grade hardware for training and serving.
- Develop and document the process for future replication.
- Explore the specialized LLM space rather than competing with foundation models.

### Non-Objectives
- Targeting Spanish from Spain or other non-Latin American Spanish-speaking regions.
- Competing with big tech companies' centralized serving approach.
- Developing foundation models.

## 2. Model Architecture

### Base Model Selection
[To be determined]

### Model Size
70 billion parameters, potentially using distillation or pruning techniques.

### Architecture Modifications
Implement QLoRA (Quantized Low-Rank Adaptation) and FSDP (Fully Sharded Data Parallel) to enable training on consumer GPUs.

## 3. Training Data

### Data Sources
- Wikipedia content for Latin American countries (3 levels of links)
- Latin American literature and books
- Constitutions of Latin American countries
- SomosNLP dataset
- OpenHermes datasets

### Data Preparation and Cleaning
we will mimick HuggingFace's FineWeb-Edu approach

### Data Format and Structure
we will mimick HuggingFace's [FineWeb-Edu](https://huggingface.co/datasets/HuggingFaceFW/fineweb-edu) approach

## 4. Training Proces
We fine-tune, we do not pre-train.

### Hardware Requirements
2x NVIDIA RTX 3090 with 24GB VRAM each

### Software Stack
- PyTorch with FSDP
- QLoRA
- bitsandbyte
- PEFT
- Transformers
- Accelerate

### Training Techniques

#### 1. Quantization (QLoRA)
- Utilize 4-bit quantization to reduce model memory footprint by ~75%
- Implement QLoRA, combining quantization with Low-Rank Adaptation
- Use a 4-bit quantized frozen base model with trainable low-rank adapters
- Employ 4-bit NormalFloat (NF4) data type for normally distributed weights
- Implement double quantization to further reduce memory usage

#### 2. Fully Sharded Data Parallel (FSDP)
- Shard model parameters, optimizer states, and gradients across multiple GPUs
- Perform all-gather operations during forward pass
- Use reduce-scatter operations for gradient synchronization during backward pass

#### 3. Gradient Checkpointing
- Trade computation for memory by not storing all activations
- Save checkpoints and recompute activations as needed during backward pass

#### 4. CPU Offloading
- Store some model parameters and optimizer states in CPU RAM when not in use
- Significantly reduce GPU memory requirements

#### 5. Flash Attention
- Implement optimized attention computation using memory-efficient CUDA kernels

#### 6. Half Quadratic Quantization (HQQ)
- Utilize HQQ as an alternative or complement to standard 4-bit quantization
- Minimize weight errors using a sparsity-promoting loss function
- Employ a half-quadratic solver for efficient optimization

#### Challenges and Considerations
- Training will be slower compared to data center GPUs
- Potential loss in model quality due to quantization
- Balancing sequence length and batch size within memory constraints
- Careful management of quantization state and FSDP synchronization



## 5. Evaluation Metrics

### Performance Metrics
We will use a variety of benchmarks to evaluate our model's performance. We will not be able to
compete (yet) with the leading models like claude, or gemini, but if we can get to within 10% of their perf, that's good enough as a starting point. 


### Evaluation Datasets and Benchmarks
We will use the following datasets and benchmarks for evaluation:

1. MMBench v1.1
2. MMStar
3. MMMU_VAL
4. MathVista_MINI
5. HallusionBench
6. AI2D_TEST
7. OCRBench
8. MMVet

Here are the benchmark scores of leading models for reference:

| Benchmark       | GPT-4o-20240513 | Claude3.5-Sonnet | Gemini-1.5-Pro | GPT-4v-20240409 |
|-----------------|-----------------|-------------------|-----------------|------------------|
| Overall Rank    | 1               | 2                 | 3               | 4                |
| Avg. Score      | 69.9            | 67.9              | 64.4            | 63.5             |
| MMBench v1.1    | 82.2            | 78.5              | 73.9            | 79.8             |
| MMStar          | 63.9            | 62.2              | 59.1            | 56.0             |
| MMMU_VAL        | 69.2            | 65.9              | 60.6            | 61.7             |
| MathVista_MINI  | 61.3            | 61.6              | 57.7            | 54.7             |
| HallusionBench  | 55.0            | 49.9              | 45.6            | 43.9             |
| AI2D_TEST       | 84.6            | 80.2              | 79.1            | 78.6             |
| OCRBench        | 736             | 788               | 754             | 656              |
| MMVet           | 69.1            | 66                | 64              | 67.5             |


## 6. Ethical Considerations
None to begin with, but we aim to open up the discussion by reaching out to researchers and thinkers. 

### Bias Mitigation Strategies
[To be developed]

### Safety Measures
None, we don't go into that hype and we don't want regulatory capture. 
+ guardrails can be added to the systems that build upon tango (e.g., nvidia's nemo guardrails)

### Privacy Considerations
[To be developed]

## 7. Deployment and Inference

### Deployment Environment
Explore decentralized and distributed hosting options suitable for the (mostly undeveloped) Latin American infrastructure.

### Inference Optimization
Implement quantization techniques like Half Quadratic Quantization (HQQ) for efficient inference.

### Scaling Considerations
see `Future Considerations` on architectures that scale sub-linearly with context lenght. 

## 8. Maintenance and Iteration
[To be determined]

### Monitoring Plan
Weights & Biases

### Version Control
Github

## 9. Timeline and Milestones
- 2024
    * test runs until september the 1st
    * data scrapping throught the week of september the 2nd
    * train tango-70b v0.0.1 over the september 7th-8th weekend
    * soft release (huggingface, linkedin) on september 9th
    * full release on october the 1st
- 2025 
    * [To be determined]

## 10. Resources and Budget

### Team Composition
lexia x sandbox

### Computing Resources
Dual RTX 3090 setup, with potential for cloud resources (e.g., Runpod Community Cloud at ~$0.60/hour)

### Estimated Costs
None if fully local, [To be calculated] if partially on cloud

## 11. Looking Forward

### Future Considerations
- Explore more cost-effective architectures (sub-linear scaling of context) such as State Space Models (Mamba and Jamba) and RNNs (RWKV)
- Investigate the potential for running AI on smartphones in Latin America over the next 2-4 years. 

## 12. Communication and Outreach

### Technical Paper/Post
Document the entire process, challenges, and solutions for the Latin American AI community.

### News article
"Argentinians build the first AI of Latin America" - highlighting cultural inclusions (e.g., writings from San Martín, Cortázar), societal impact, geopolitical derivations.


### "The Geopolitics of LLMs and can Argentina be the next big AI player?"
discussing the potential and challenges for Argentina in the global AI landscape.

- (some) of the questions to be answered: 
    * Are there political or geographical reasons for argentina and latam to develop and host it's own AI?
    * Can foreign AI properly represent our values and interests as latinoamericans?
    * Can foreignly trained and/or served AI be properly in control of latam owners?

### "The economics of hosting and serving LLMs in Latin America"
sxploring the feasibility and implications of local (and potentially distributed and decentralized) AI infrastructure.

- (some) of the questions to be answered: 
    * Is it convenient to host llms on latin america? why not just pay the us, france or china to serve them for us?
    * If it's not economically convenient to serve them here, why is it that the case? are we missing a hidden cost or benefit? e.g., progressively buying/getting the compute to build AI infrastructure in latin america. 
    * If most AI services cost 20 USD per month, why should latam countries pay that? can we get a business going by charging the equivalent on % of minimum wage? --> e.g. if 20USD per month is say 2% of minimum wage in the US, can we get a business going by charging 2% of Argentina/Latam's minimum wage? buying compute is certainly the same cost -given we can get some gpus on our hands- but certainly the cost of running the compute should be cheaper. (and most likely we should go for something like ROCm instead of CUDA)
    * Are there economic reasons/drivers to develp AI infrastructure in Latam? is it sortof the equivalent to energetic selfsustainability? What other drivers are there? geopolitical ones? War/Military ones? what happens if a latam country goes to war or get's into political conflict with it's provider of AI infrastructure? isn't it too risky to not have our own infrastructure?
    * Is de-centralization the solution to cheap AI serving? since we don't have the money to pay for everyones compute, then we should just use the decentralized and distributed compute on everyone's phone? Can we expect to have enough power on our smartphones to run useful AI on our phones? if not in 2 years (Moore's law?), in how many years? Can Argentina and Latam prepare for when this happens?
