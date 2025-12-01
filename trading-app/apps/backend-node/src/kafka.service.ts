import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { Kafka, Consumer } from 'kafkajs';

@Injectable()
export class KafkaService implements OnModuleDestroy {
  private kafka: Kafka;
  private consumer: Consumer;

  constructor() {
    this.kafka = new Kafka({
      clientId: 'nestjs-app',
      brokers: ['kafka:9092'], // o localhost:9092
    });

    this.consumer = this.kafka.consumer({ groupId: 'nestjs-consumer' });
  }

  async consume(topic: string, callback: (message: any) => void) {
    await this.consumer.connect();
    await this.consumer.subscribe({ topic, fromBeginning: false });

    /* eslint-disable @typescript-eslint/require-await */
    await this.consumer.run({
      eachMessage: async ({ message }) => {
        callback(message.value?.toString());
      },
    });

    console.log('Kafka Consumer escuchando:', topic);
  }

  async onModuleDestroy() {
    await this.consumer.disconnect();
  }
}
