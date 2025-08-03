package main

import (
	"fmt"
	"time"

	kafka "github.com/lasandun/kafkalib/v3/pkg/producer"
)

func produceOne(producerWrapper *kafka.ProducerWrapper) {
	if producerWrapper == nil {
		fmt.Println("failed to initialize kafka producer")
	}

	err := producerWrapper.Produce("test1", []byte("test message"))
	if err != nil {
		fmt.Println("failed to produce message", err)
	}
}

func main() {
	producerWrapper := kafka.NewProducerWrapper("localhost:9092")

	defer producerWrapper.Close()

	go func() {
		for {
			produceOne(producerWrapper)
			time.Sleep(5 * time.Second)
		}
	}()

	// Prevent main from exiting immediately
	select {}
}
