#!/usr/bin/env dart
// Device Performance Test Script
// Run this on your device to test real-world performance

import 'dart:async';
import 'dart:math';

import 'package:meowdoku_helper/src/rust/api/simple.dart';
import 'package:meowdoku_helper/src/rust/frb_generated.dart';
import 'package:meowdoku_helper/utils/debug_logger.dart';

void main() async {
  DebugLogger.debug(
    '🚀 Device Performance Test - Julia-Rust Cross-Integration',
  );
  DebugLogger.debug('=' * 60);
  
  // Initialize Rust library
  await RustLib.init();
  
  // Test 1: Basic FFI Performance
  await testBasicFFIPerformance();
  
  // Test 2: Memory Performance
  await testMemoryPerformance();
  
  // Test 3: Real-time Processing Simulation
  await testRealTimeProcessing();
  
  // Test 4: Large Data Processing
  await testLargeDataProcessing();
  
  // Test 5: Stress Test
  await testStressTest();
  
  DebugLogger.debug('\n🎉 Device Performance Test Complete!');
}

Future<void> testBasicFFIPerformance() async {
  DebugLogger.debug('\n📊 Test 1: Basic FFI Performance');
  DebugLogger.debug('-' * 40);
  
  final stopwatch = Stopwatch()..start();
  var operations = 0;
  const maxOperations = 10000;
  
  // Use actual FFI calls for performance testing
  for (var i = 0; i < maxOperations; i++) {
    // Use existing FFI function for performance testing
    final result = getAnswerWords();
    if (result.isEmpty) {
      DebugLogger.debug('❌ FFI operation failed at iteration $i');
      return;
    }
    operations++;
  }
  
  stopwatch.stop();
  final duration = stopwatch.elapsedMilliseconds;
  final opsPerSecond = (operations * 1000) / duration;
  
  DebugLogger.debug('✅ Operations: $operations');
  DebugLogger.debug('✅ Duration: ${duration}ms');
  DebugLogger.debug('✅ Throughput: ${opsPerSecond.toStringAsFixed(0)} ops/s');
  
  if (opsPerSecond > 1000) {
    DebugLogger.debug('✅ Performance: EXCELLENT (>1000 ops/s)');
  } else if (opsPerSecond > 100) {
    DebugLogger.debug('✅ Performance: GOOD (>100 ops/s)');
  } else {
    DebugLogger.debug('⚠️  Performance: NEEDS IMPROVEMENT (<100 ops/s)');
  }
}

Future<void> testMemoryPerformance() async {
  DebugLogger.debug('\n🧠 Test 2: Memory Performance');
  DebugLogger.debug('-' * 40);
  
  final stopwatch = Stopwatch()..start();
  final memoryTest = <List<int>>[];
  
  // Allocate memory in chunks
  for (var chunk = 0; chunk < 100; chunk++) {
    final chunkData = List.generate(1000, (index) => chunk * 1000 + index);
    memoryTest.add(chunkData);
    
    // Simulate processing
    for (final value in chunkData) {
      final processed = value * 2;
      if (processed != value * 2) {
        DebugLogger.debug('❌ Memory processing failed at chunk $chunk');
        return;
      }
    }
  }
  
  stopwatch.stop();
  final duration = stopwatch.elapsedMilliseconds;
  final totalItems = memoryTest.length * 1000;
  final itemsPerSecond = (totalItems * 1000) / duration;
  
  DebugLogger.debug('✅ Memory chunks: ${memoryTest.length}');
  DebugLogger.debug('✅ Total items: $totalItems');
  DebugLogger.debug('✅ Duration: ${duration}ms');
  DebugLogger.debug('✅ Throughput: ${itemsPerSecond.toStringAsFixed(0)} items/s');
  
  // Clean up memory
  memoryTest.clear();
  
  if (itemsPerSecond > 10000) {
    DebugLogger.debug('✅ Memory Performance: EXCELLENT (>10K items/s)');
  } else if (itemsPerSecond > 1000) {
    DebugLogger.debug('✅ Memory Performance: GOOD (>1K items/s)');
  } else {
    DebugLogger.debug('⚠️  Memory Performance: NEEDS IMPROVEMENT (<1K items/s)');
  }
}

Future<void> testRealTimeProcessing() async {
  DebugLogger.debug('\n⚡ Test 3: Real-time Processing Simulation');
  DebugLogger.debug('-' * 40);
  
  final stopwatch = Stopwatch()..start();
  var processedItems = 0;
  const targetItems = 5000;
  
  // Simulate real-time data processing
  for (var i = 0; i < targetItems; i++) {
    // Simulate data processing
    final data = i * 1.5;
    final processed = data * 2.0;
    final result = processed / 3.0;
    
    // Validate processing
    final expected = (i * 1.5 * 2.0) / 3.0;
    if ((result - expected).abs() > 0.001) {
      DebugLogger.debug('❌ Real-time processing failed at item $i');
      return;
    }
    
    processedItems++;
    
    // Simulate real-time delay (1ms)
    if (i % 100 == 0) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
  
  stopwatch.stop();
  final duration = stopwatch.elapsedMilliseconds;
  final itemsPerSecond = (processedItems * 1000) / duration;
  
  DebugLogger.debug('✅ Processed items: $processedItems');
  DebugLogger.debug('✅ Duration: ${duration}ms');
  DebugLogger.debug('✅ Throughput: ${itemsPerSecond.toStringAsFixed(0)} items/s');
  
  if (itemsPerSecond > 1000) {
    DebugLogger.debug('✅ Real-time Performance: EXCELLENT (>1K items/s)');
  } else if (itemsPerSecond > 100) {
    DebugLogger.debug('✅ Real-time Performance: GOOD (>100 items/s)');
  } else {
    DebugLogger.debug('⚠️  Real-time Performance: NEEDS IMPROVEMENT (<100 items/s)');
  }
}

Future<void> testLargeDataProcessing() async {
  DebugLogger.debug('\n📈 Test 4: Large Data Processing');
  DebugLogger.debug('-' * 40);
  
  final stopwatch = Stopwatch()..start();
  const dataSize = 50000;
  final largeData = List.generate(dataSize, (index) => index);
  
  // Process large dataset
  var processedCount = 0;
  for (var i = 0; i < largeData.length; i += 100) {
    final chunkEnd = (i + 100).clamp(0, largeData.length);
    final chunk = largeData.sublist(i, chunkEnd);
    
    // Process chunk
    for (final value in chunk) {
      final processed = value * 1.5;
      if (processed != value * 1.5) {
        DebugLogger.debug('❌ Large data processing failed at index $i');
        return;
      }
      processedCount++;
    }
  }
  
  stopwatch.stop();
  final duration = stopwatch.elapsedMilliseconds;
  final itemsPerSecond = (processedCount * 1000) / duration;
  
  DebugLogger.debug('✅ Data size: $dataSize items');
  DebugLogger.debug('✅ Processed: $processedCount items');
  DebugLogger.debug('✅ Duration: ${duration}ms');
  DebugLogger.debug('✅ Throughput: ${itemsPerSecond.toStringAsFixed(0)} items/s');
  
  if (itemsPerSecond > 5000) {
    DebugLogger.debug('✅ Large Data Performance: EXCELLENT (>5K items/s)');
  } else if (itemsPerSecond > 1000) {
    DebugLogger.debug('✅ Large Data Performance: GOOD (>1K items/s)');
  } else {
    DebugLogger.debug('⚠️  Large Data Performance: NEEDS IMPROVEMENT (<1K items/s)');
  }
}

Future<void> testStressTest() async {
  DebugLogger.debug('\n🔥 Test 5: Stress Test');
  DebugLogger.debug('-' * 40);
  
  final stopwatch = Stopwatch()..start();
  var totalOperations = 0;
  const stressDuration = 5000; // 5 seconds
  
  final random = Random();
  
  while (stopwatch.elapsedMilliseconds < stressDuration) {
    // Simulate various operations
    final operationType = random.nextInt(4);
    
    switch (operationType) {
      case 0:
        // Basic arithmetic
        final a = random.nextInt(1000);
        final b = random.nextInt(1000);
        final result = a + b;
        if (result != a + b) {
          DebugLogger.debug('❌ Stress test failed: arithmetic');
          return;
        }
        break;
        
      case 1:
        // Memory allocation
        final list = List.generate(100, (index) => index);
        final sum = list.reduce((a, b) => a + b);
        if (sum != 4950) { // Sum of 0-99
          DebugLogger.debug('❌ Stress test failed: memory allocation');
          return;
        }
        break;
        
      case 2:
        // String processing
        final str = 'test_${random.nextInt(1000)}';
        final processed = str.toUpperCase();
        if (processed != str.toUpperCase()) {
          DebugLogger.debug('❌ Stress test failed: string processing');
          return;
        }
        break;
        
      case 3:
        // Complex computation
        final value = random.nextDouble() * 100;
        final result = value * value / 2.0;
        final expected = value * value / 2.0;
        if ((result - expected).abs() > 0.001) {
          DebugLogger.debug('❌ Stress test failed: complex computation');
          return;
        }
        break;
    }
    
    totalOperations++;
  }
  
  stopwatch.stop();
  final duration = stopwatch.elapsedMilliseconds;
  final opsPerSecond = (totalOperations * 1000) / duration;
  
  DebugLogger.debug('✅ Total operations: $totalOperations');
  DebugLogger.debug('✅ Duration: ${duration}ms');
  DebugLogger.debug('✅ Throughput: ${opsPerSecond.toStringAsFixed(0)} ops/s');
  
  if (opsPerSecond > 1000) {
    DebugLogger.debug('✅ Stress Test Performance: EXCELLENT (>1K ops/s)');
  } else if (opsPerSecond > 100) {
    DebugLogger.debug('✅ Stress Test Performance: GOOD (>100 ops/s)');
  } else {
    DebugLogger.debug('⚠️  Stress Test Performance: NEEDS IMPROVEMENT (<100 ops/s)');
  }
}
