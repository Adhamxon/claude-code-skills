---
name: ai-ml-engineering
description: AI/ML Engineering — LLM APIs (OpenAI, Claude, Gemini, Mistral), RAG systems, AI agents, vector databases, fine-tuning, MCP servers. Use when integrating LLMs, building RAG pipelines, creating AI agents, or working with ML models.
---

# AI/ML Engineering Skill

## LLM APIs

### OpenAI (Python)
```python
from openai import OpenAI
client = OpenAI()
stream = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hello"}],
    stream=True,
    tools=[{
        "type": "function",
        "function": {"name": "get_weather", "parameters": {"type": "object", "properties": {"city": {"type": "string"}}}}
    }]
)
```

### Anthropic Claude (TypeScript)
```typescript
import Anthropic from '@anthropic-ai/sdk';
const client = new Anthropic();
const msg = await client.messages.create({
  model: 'claude-sonnet-4-20250514',
  max_tokens: 1024,
  messages: [{ role: 'user', content: 'Hello' }],
});
```

### Model Selection Guide
| Model | Best For | Speed | Cost/1M tokens |
|-------|----------|-------|----------------|
| GPT-4o | Complex reasoning, tool use | Medium | $2.50/$10.00 |
| Claude Sonnet 4 | Code, analysis, long context | Fast | $3.00/$15.00 |
| Gemini 2.5 Pro | Multimodal, 1M context | Medium | $1.25/$5.00 |
| Mistral Large | Multilingual, code | Fast | $2.00/$6.00 |
| Groq Llama 3 | Ultra-fast inference | Very Fast | $0.59/$0.79 |

## RAG Architecture (Production)
```
Documents → Chunking → Embeddings → Vector DB → Retrieval → LLM → Response
                ↓            ↓            ↓            ↓
          SentenceSplitter  text-embedding-3-small  Pinecone/Weaviate/Qdrant
          
# Chunking strategies
- Fixed size: 512 tokens + 50 overlap (general)
- Semantic: sentence boundaries (narrative)
- Recursive: HTML/Markdown headers (documents)

# Hybrid Search = Vector + Keyword (BM25)
results = vector_store.hybrid_search(query, alpha=0.5)
```

### LangChain Example
```python
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter

texts = ["AI is transforming software development"]
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
docs = splitter.create_documents(texts)
vectorstore = Chroma.from_documents(docs, OpenAIEmbeddings())
retriever = vectorstore.as_retriever(search_kwargs={"k": 3})
```

## AI Agents
```python
# LangGraph agent
from langgraph.graph import StateGraph
from langchain_core.messages import HumanMessage

workflow = StateGraph(dict)
workflow.add_node("agent", call_model)
workflow.add_node("tools", tool_executor)
workflow.set_entry_point("agent")
workflow.add_conditional_edges("agent", should_continue, {"continue": "tools", "end": "__end__"})
workflow.add_edge("tools", "agent")
app = workflow.compile()
```

## Vector Databases
| DB | Best For | Hosting |
|----|----------|---------|
| Pinecone | Production, managed | Cloud |
| Weaviate | Hybrid search, CRUD | Self/Cloud |
| Qdrant | Performance, filtering | Self/Cloud |
| Chroma | Development, lightweight | Embedded |
| Milvus | Large scale, GPU | Self/Cloud |

## Fine-tuning (LoRA)
```python
from peft import LoraConfig, get_peft_model
config = LoraConfig(r=8, lora_alpha=32, target_modules=["q_proj", "v_proj"])
model = get_peft_model(base_model, config)
```

## AI Safety Checklist
- [ ] Prompt injection prevention (input sanitization, system prompt hardening)
- [ ] Output validation (PII filtering, content moderation)
- [ ] Rate limiting per user/IP
- [ ] Cost limits per session
- [ ] Hallucination detection (citation, confidence scores)
- [ ] Guardrails (NeMo Guardrails, Guardrails AI)

## MCP Servers
MCP (Model Context Protocol) connects LLMs to external tools:
```python
from mcp.server.fastmcp import FastMCP
server = FastMCP("My Service")
@server.tool()
def query_database(sql: str) -> str:
    """Execute read-only SQL query"""
    return str(db.execute(sql))
```
