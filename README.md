# Content Understanding – Model Configuration Guide

## Overview

Azure AI Content Understanding uses AI models to analyze documents and extract information. Two types of models are required:

| Model Type | Purpose | Supported Models |
|---|---|---|
| **Completion** | Powers document analysis, field extraction, and content understanding | `gpt-4.1`, `gpt-4.1-mini`, `gpt-4o` |
| **Embedding** | Generates vector representations for semantic search and similarity | `text-embedding-3-large` |

*NOTE*: Studio UI only show global deployment type. `gpt-4.1`, `gpt-4.1-mini` are required model for some pre-built analyzers which can not be changed. We can only change the deployment type of these models from global to regional based. 
 

## How Model Configuration Works

Model configuration in Content Understanding has **two layers**:

### 1. Default Model Deployments (Resource-Level)

Before any analyzer can use a model, the **model deployment mapping** must be registered at the Content Understanding resource level. This mapping tells Content Understanding which Azure OpenAI deployment name corresponds to each model.

For example, if your Azure OpenAI deployment for `gpt-4.1` is named `gpt-4.1-189637`, the mapping would be:

| Model Name | Deployment Name |
|---|---|
| `gpt-4.1` | `gpt-4.1-189637` |
| `gpt-4.1-mini` | `gpt-4.1-mini` |
| `gpt-4o` | `gpt-4o` |
| `text-embedding-3-large` | `text-embedding-3-large` |

> **Key point:** The model name and deployment name can differ. The deployment name must match the actual deployment in your Azure AI Foundry resource. If a model is not registered in the defaults, it will not be available for use.

### 2. Analyzer-Level Model Selection

When you create or configure an analyzer (e.g., in Content Understanding Studio), you select which completion and embedding models that analyzer should use:

- **Completion model** – e.g., `gpt-4o`, `gpt-4.1`, or `gpt-4.1-mini`
- **Embedding model** – e.g., `text-embedding-3-large`

The analyzer can only reference models that have already been registered in the default model deployments.

## Common Issues in Content Understanding Studio UI

### "Model not available" or no models listed

**Cause:** The model deployment mapping has not been configured at the resource level, or the deployment name does not match an actual deployment in your Azure AI Foundry resource.

**Resolution:**
1. Verify the model is deployed in your Azure AI Foundry resource.
2. Ensure the default model deployment mapping is set, so Content Understanding knows which deployment name to use for each model. This can be done via the REST API (`PATCH /contentunderstanding/defaults`) or through the Foundry portal.

### Analyzer fails with model-related errors

**Cause:** The analyzer references a model that is either not mapped in the defaults or whose underlying deployment has been deleted or renamed.

**Resolution:**
1. Check the current defaults by calling `GET /contentunderstanding/defaults`.
2. Confirm the deployment name in the mapping still matches a live deployment in your Azure AI Foundry resource.
3. Update the mapping if the deployment name has changed.

### Which model should I choose?

| Model | Best For |
|---|---|
| `gpt-4.1` | Highest accuracy, complex documents, production workloads requiring best quality |
| `gpt-4.1-mini` | Cost-efficient option, good balance of quality and speed for simpler documents |
| `gpt-4o` | General purpose, strong multimodal capabilities |

## Summary

```
┌─────────────────────────────────────────────────┐
│       Azure AI Foundry Resource                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Model Deployments                       │   │
│  │  • gpt-4.1  → deployment: gpt-4.1-xxx   │   │
│  │  • gpt-4o   → deployment: gpt-4o        │   │
│  │  • text-embedding-3-large → deployment   │   │
│  └──────────────────────────────────────────┘   │
│                     ▲                           │
│                     │ mapped via                │
│                     │ /defaults                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Content Understanding                   │   │
│  │  Default Model Deployments               │   │
│  │  (model name → deployment name)          │   │
│  └──────────────────────────────────────────┘   │
│                     ▲                           │
│                     │ referenced by             │
│  ┌──────────────────────────────────────────┐   │
│  │  Analyzer (e.g., "myReceipt")            │   │
│  │  • completion: gpt-4o                    │   │
│  │  • embedding: text-embedding-3-large     │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```



