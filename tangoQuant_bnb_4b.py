import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig


bnb_config = BitsAndBytesConfig(load_in_4bit=True,bnb_4bit_use_double_quant=True, bnb_4bit_quant_type="nf4", bnb_4bit_compute_dtype=torch.bfloat16)
model_id = 'Model-SafeTensors/Llama-3.1-Tango-70b'
tokenizer = AutoTokenizer.from_pretrained(model_id)

model_4bit = AutoModelForCausalLM.from_pretrained(model_id, quantization_config=bnb_config, device_map="auto")

model_4bit.save_pretrained("tango-70b_bnb-4bit")
tokenizer.save_pretrained("tango-70b_bnb-4bit")

model_4bit.push_to_hub("sandbox-ai/Llama-3.1-Tango-70b-bnb_4b", token = "...")

tokenizer.push_to_hub("sandbox-ai/Llama-3.1-Tango-70b-bnb_4b", token = "...")
