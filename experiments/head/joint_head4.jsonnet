local transformer_model = "roberta-base";
local transformer_hidden_dim = 768;
local epochs = 6;
local batch_size = 8;
local max_length = 512;

{
    "dataset_reader": {
        "type": "joint",
        "token_indexers": {
          "tokens": {
            "type": "pretrained_transformer_mismatched",
            "model_name": transformer_model,
            "max_length": max_length
          },
        },
    },
    "train_data_path": "/home/nlp/pyatkiv/workspace/Modality/data/4/train_prejacent_five_head.txt",
    "validation_data_path": "/home/nlp/pyatkiv/workspace/Modality/data/4/dev_prejacent_five_head.txt",
    "data_loader": {
        "batch_sampler": {
            "type": "bucket",
            "batch_size": batch_size
        }
    },
    "model": {
        "type": "simple_tagger_mod",
        "encoder": {
            "type": "pass_through",
            "input_dim": transformer_hidden_dim,
        },
        "text_field_embedder": {
          "token_embedders": {
            "tokens": {
                "type": "pretrained_transformer_mismatched",
                "model_name": transformer_model,
                "max_length": max_length
            }
          }
        },
        "verbose_metrics": true
    },
    "trainer": {
        "optimizer": {
          "type": "huggingface_adamw",
          "weight_decay": 0.0,
          "parameter_groups": [[["bias", "LayerNorm\\.weight", "layer_norm\\.weight"], {"weight_decay": 0}]],
          "lr": 1e-5,
          "eps": 1e-8
        },
        "learning_rate_scheduler": {
          "type": "slanted_triangular",
          "cut_frac": 0.05,
        },
        "grad_norm": 1.0,
        "num_epochs": epochs,
        "cuda_device": 0,
        "validation_metric": "+tagging_f1"
    }
}