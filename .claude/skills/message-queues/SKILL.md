---
name: message-queues
description: Message Queues & Event Streaming — Apache Kafka, RabbitMQ, Redis Streams, SQS/SNS, BullMQ, patterns (pub/sub, competing consumers, saga), exactly-once semantics. Use when designing event-driven systems or working with message brokers.
---

# Message Queues & Event Streaming Skill

## Message Broker Comparison

| Broker | Model | Persistence | Ordering | Throughput | Use Case |
|--------|-------|-------------|----------|------------|----------|
| **Apache Kafka** | Log-based | Disk (configurable retention) | Per-partition | 1M+ msg/s | Event streaming, data pipelines |
| **RabbitMQ** | Queue-based | Disk/memory | Per-queue (basic) | 50K msg/s | Task queues, RPC, routing |
| **Redis Streams** | Log-based | Memory + disk | Per-stream | 100K msg/s | Real-time, caching |
| **AWS SQS** | Queue-based | Disk (AWS) | Best-effort (FIFO: exact) | Unlimited | Serverless, decoupling |
| **NATS** | Pub/Sub | Memory | No | 10M+ msg/s | High-speed messaging, IoT |
| **BullMQ** | Queue-based | Redis | Per-queue | 10K msg/s | Node.js job queues |

## Apache Kafka

### Core Concepts
```
Topic (event category)
  └── Partition 0 ─── [msg1, msg2, msg3] ← Consumer Group A
  └── Partition 1 ─── [msg4, msg5, msg6] ← Consumer Group A
  └── Partition 2 ─── [msg7, msg8, msg9] ← Consumer Group B (different)

Key Concepts:
- Offset: Position of message in partition
- Consumer Group: Multiple consumers share work
- Retention: Configurable time/size (default 7 days)
- Replication: Data is replicated across brokers (replication.factor=3)
```

### Producer (Node.js)
```typescript
import { Kafka } from 'kafkajs';

const kafka = new Kafka({ brokers: ['localhost:9092'], clientId: 'order-service' });
const producer = kafka.producer();

await producer.connect();
await producer.send({
  topic: 'order-events',
  messages: [
    {
      key: 'order-123',                    // Same key → same partition (ordering preserved)
      value: JSON.stringify({
        orderId: '123',
        userId: 'user_456',
        total: 99.99,
        action: 'order_created',
        timestamp: Date.now(),
      }),
      headers: { 'event-type': 'order.created' },
    },
  ],
});

// Idempotent producer (exactly-once)
const producer = kafka.producer({ allowAutoTopicCreation: true, transactionTimeout: 30000 });
await producer.connect();
await producer.send({
  topic: 'payments',
  messages: [{ value: JSON.stringify({ paymentId, amount }) }],
  acks: -1, // Wait for all replicas
});
```

### Consumer (Node.js)
```typescript
const consumer = kafka.consumer({ groupId: 'order-processing-group' });
await consumer.connect();
await consumer.subscribe({ topic: 'order-events', fromBeginning: false });

await consumer.run({
  eachMessage: async ({ topic, partition, message, heartbeat, pause }) => {
    try {
      const event = JSON.parse(message.value!.toString());
      await processOrder(event);
      await heartbeat(); // Keep alive
    } catch (err) {
      // Dead letter queue pattern
      await producer.send({
        topic: 'order-events-dlq',
        messages: [{ value: message.value, headers: { 'error': err.message } }],
      });
    }
  },
  // Batch processing
  eachBatch: async ({ batch, resolveOffset, heartbeat }) => {
    const events = batch.messages.map(m => JSON.parse(m.value!.toString()));
    await bulkProcess(events);
    // Commit offsets after successful batch
    for (const message of batch.messages) {
      await resolveOffset(message.offset);
    }
  },
});
```

### Kafka Architecture
```
Partition count = max(throughput_needed / single_partition_throughput, consumer_count)
Replication factor = 3 (production)
Retention = 7 days (default), can be time/size based
Compaction: Keep latest value per key (for stateful events)
```

## RabbitMQ

### Exchange Types
```typescript
import amqp from 'amqplib';

const conn = await amqp.connect('amqp://localhost');
const channel = await conn.createChannel();

// 1. Direct Exchange (routing by routing key)
await channel.assertExchange('order-direct', 'direct', { durable: true });
await channel.bindQueue('payment-queue', 'order-direct', 'payment');
await channel.publish('order-direct', 'payment', Buffer.from(JSON.stringify(order)));

// 2. Topic Exchange (routing by pattern)
await channel.assertExchange('order-topic', 'topic', { durable: true });
await channel.bindQueue('europe-orders', 'order-topic', 'order.europe.*');
await channel.publish('order-topic', 'order.europe.created', Buffer.from(data));

// 3. Fanout Exchange (broadcast to all queues)
await channel.assertExchange('notifications', 'fanout', { durable: true });
await channel.bindQueue('email-queue', 'notifications', '');
await channel.bindQueue('sms-queue', 'notifications', '');
await channel.publish('notifications', '', Buffer.from(data));

// 4. Headers Exchange (routing by headers)
await channel.assertExchange('order-headers', 'headers', { durable: true });
await channel.bindQueue('urgent-queue', 'order-headers', '', { 'x-match': 'all', priority: 'high' });
```

### Worker (Competing Consumers)
```typescript
// Producer
channel.sendToQueue('task-queue', Buffer.from(task), {
  persistent: true,         // Survive broker restart
  priority: task.priority,  // Priority queue
  expiration: 60000,        // TTL (1 minute)
});

// Consumer (with prefetch)
await channel.prefetch(1); // Process one at a time
await channel.consume('task-queue', async (msg) => {
  try {
    await processTask(JSON.parse(msg.content.toString()));
    channel.ack(msg);
  } catch (err) {
    if (msg.fields.redelivered) {
      channel.reject(msg, false); // Don't requeue → DLQ
    } else {
      channel.nack(msg, false, true); // Requeue
    }
  }
});
```

## Redis Streams

```typescript
import { Redis } from 'ioredis';

const redis = new Redis();

// Producer
await redis.xadd('mystream', '*', 'event', 'order.created', 'orderId', '123');

// Consumer Group
await redis.xgroup('CREATE', 'mystream', 'mygroup', '$', 'MKSTREAM');

// Read from consumer group
const results = await redis.xreadgroup(
  'GROUP', 'mygroup', 'consumer1',
  'BLOCK', 5000,
  'COUNT', 10,
  'STREAMS', 'mystream', '>'
);

// Acknowledge
await redis.xack('mystream', 'mygroup', messageId);
```

## AWS SQS/SNS

```typescript
import { SQS } from '@aws-sdk/client-sqs';

const sqs = new SQS({ region: 'us-east-1' });

// Send message
await sqs.sendMessage({
  QueueUrl: 'https://sqs.us-east-1.amazonaws.com/123/orders',
  MessageBody: JSON.stringify(order),
  MessageGroupId: order.userId,    // FIFO: ordering within group
  MessageDeduplicationId: order.id, // FIFO: dedup
  DelaySeconds: 0,
});

// Receive (long polling)
const messages = await sqs.receiveMessage({
  QueueUrl: queueUrl,
  MaxNumberOfMessages: 10,
  WaitTimeSeconds: 20, // Long polling (reduce empty responses)
  VisibilityTimeout: 30, // Message invisible for 30s while processing
});

// Delete after processing
await sqs.deleteMessage({ QueueUrl: queueUrl, ReceiptHandle: msg.ReceiptHandle });
```

## Patterns

### Saga Pattern (Distributed Transactions)
```typescript
// Choreography-based saga
// 1. Order Service: Create order (PENDING) → emit ORDER_CREATED
// 2. Payment Service: Handle ORDER_CREATED → process payment → emit PAYMENT_PROCESSED / PAYMENT_FAILED
// 3. Inventory Service: Handle PAYMENT_PROCESSED → reserve stock → emit STOCK_RESERVED / STOCK_FAILED
// 4. On FAILURE: emit compensating events (CANCEL_PAYMENT, RELEASE_STOCK)

// Orchestrator-based saga
class OrderSagaOrchestrator {
  async execute(orderId: string) {
    try {
      await this.createOrder(orderId);
      await this.processPayment(orderId);
      await this.reserveInventory(orderId);
      await this.confirmOrder(orderId);
    } catch (err) {
      await this.compensate(orderId);
    }
  }
}
```

### Dead Letter Queue (DLQ)
```
Main Queue → Processing → Success (ACK)
                          → Failure (retry 3x) → DLQ → Manual inspection
                                                     → Reprocess via admin tool
```

## Best Practices
- **Idempotency**: Messages should be processable multiple times
- **Ordering**: Same key → same partition/group for ordered processing
- **Retry**: Exponential backoff (1s, 2s, 4s, 8s...) with max retries
- **Monitoring**: Queue depth, consumer lag, throughput, error rate
- **Security**: TLS encryption, SASL/SCRAM auth, ACLs
- **Schema Registry**: Avro/Protobuf schemas for compatibility
