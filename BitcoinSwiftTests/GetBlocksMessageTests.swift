//
//  GetBlocksMessageTests.swift
//  BitcoinSwift
//
//  Created by Kevin Greene on 9/27/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class GetBlocksMessageTests: XCTestCase {

  let blockLocatorHash0Bytes: [UInt8] = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x15, 0x64, 0xe4, 0x24, 0x80, 0xf3, 0xae, 0x48,
      0x26, 0x64, 0xa9, 0xae, 0xbc, 0x72, 0xc4, 0xc6,
      0xa1, 0xf0, 0x9b, 0x50, 0x7c, 0x25, 0x73, 0x0b]
  let blockLocatorHash1Bytes: [UInt8] = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x15, 0x90, 0x8e, 0xd4, 0x38, 0xb4, 0xc7, 0xff,
      0x3f, 0xbc, 0x56, 0x29, 0x03, 0x14, 0x0d, 0x43,
      0x22, 0x38, 0xd6, 0xd7, 0x8d, 0x28, 0x73, 0x70]
  let blockHashStopBytes: [UInt8] = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x0a, 0x72, 0xd2, 0xe6, 0x63, 0x4a, 0x71, 0x6f,
      0x3c, 0x51, 0x92, 0x1e, 0xe4, 0x47, 0x4c, 0x25,
      0x33, 0x48, 0x0b, 0xa7, 0x44, 0xd8, 0xf7, 0x24]

  var blockLocatorHash0: NSData!
  var blockLocatorHash1: NSData!
  var blockHashStop: NSData!

  override func setUp() {
    blockLocatorHash0 = NSData(bytes:blockLocatorHash0Bytes,
                               length:blockLocatorHash0Bytes.count)
    blockLocatorHash1 = NSData(bytes:blockLocatorHash1Bytes,
                               length:blockLocatorHash1Bytes.count)
    blockHashStop = NSData(bytes:blockHashStopBytes, length:blockHashStopBytes.count)
  }

  func testGetBlocksMessageDecoding() {
    let bytes: [UInt8] = [
        0x71, 0x11, 0x01, 0x00,                           // 70001 (protocol version 70001)
        0x02,                                             // Number of block locator hashes (2)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x64, 0xe4, 0x24, 0x80, 0xf3, 0xae, 0x48,
        0x26, 0x64, 0xa9, 0xae, 0xbc, 0x72, 0xc4, 0xc6,
        0xa1, 0xf0, 0x9b, 0x50, 0x7c, 0x25, 0x73, 0x0b,   // blockLocatorHash0
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x90, 0x8e, 0xd4, 0x38, 0xb4, 0xc7, 0xff,
        0x3f, 0xbc, 0x56, 0x29, 0x03, 0x14, 0x0d, 0x43,
        0x22, 0x38, 0xd6, 0xd7, 0x8d, 0x28, 0x73, 0x70,   // blockLocatorHash1
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0a, 0x72, 0xd2, 0xe6, 0x63, 0x4a, 0x71, 0x6f,
        0x3c, 0x51, 0x92, 0x1e, 0xe4, 0x47, 0x4c, 0x25,
        0x33, 0x48, 0x0b, 0xa7, 0x44, 0xd8, 0xf7, 0x24]   // blockHashStop
    let data = NSData(bytes:bytes, length:bytes.count)
    if let getBlocksMessage = GetBlocksMessage.fromData(data) {
      XCTAssertEqual(getBlocksMessage.protocolVersion, 70001)
      XCTAssertEqual(getBlocksMessage.blockLocatorHashes, [blockLocatorHash0, blockLocatorHash1])
      XCTAssertNotNil(getBlocksMessage.blockHashStop)
      XCTAssertEqual(getBlocksMessage.blockHashStop!, blockHashStop)
    } else {
      XCTFail("\n[FAIL] Failed to parse GetBlocksMessage")
    }
  }

  func testGetBlocksMessageWithNoBlockHashStopDecoding() {
    let bytes: [UInt8] = [
        0x71, 0x11, 0x01, 0x00,                           // 70001 (protocol version 70001)
        0x02,                                             // Number of block locator hashes (2)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x64, 0xe4, 0x24, 0x80, 0xf3, 0xae, 0x48,
        0x26, 0x64, 0xa9, 0xae, 0xbc, 0x72, 0xc4, 0xc6,
        0xa1, 0xf0, 0x9b, 0x50, 0x7c, 0x25, 0x73, 0x0b,   // blockLocatorHash0
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x90, 0x8e, 0xd4, 0x38, 0xb4, 0xc7, 0xff,
        0x3f, 0xbc, 0x56, 0x29, 0x03, 0x14, 0x0d, 0x43,
        0x22, 0x38, 0xd6, 0xd7, 0x8d, 0x28, 0x73, 0x70,   // blockLocatorHash1
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]   // blockHashStop
    let data = NSData(bytes:bytes, length:bytes.count)
    if let getBlocksMessage = GetBlocksMessage.fromData(data) {
      XCTAssertEqual(getBlocksMessage.protocolVersion, 70001)
      XCTAssertEqual(getBlocksMessage.blockLocatorHashes, [blockLocatorHash0, blockLocatorHash1])
      XCTAssertNil(getBlocksMessage.blockHashStop)
    } else {
      XCTFail("\n[FAIL] Failed to parse GetBlocksMessage")
    }
  }

  func testGetBlocksMessageEncoding() {
    let getBlocksMessage =
        GetBlocksMessage(protocolVersion:70001,
                         blockLocatorHashes:[blockLocatorHash0, blockLocatorHash1],
                         blockHashStop:blockHashStop)
    let expectedBytes: [UInt8] = [
        0x71, 0x11, 0x01, 0x00,                           // 70001 (protocol version 70001)
        0x02,                                             // Number of block locator hashes (2)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x64, 0xe4, 0x24, 0x80, 0xf3, 0xae, 0x48,
        0x26, 0x64, 0xa9, 0xae, 0xbc, 0x72, 0xc4, 0xc6,
        0xa1, 0xf0, 0x9b, 0x50, 0x7c, 0x25, 0x73, 0x0b,   // blockLocatorHash0
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x90, 0x8e, 0xd4, 0x38, 0xb4, 0xc7, 0xff,
        0x3f, 0xbc, 0x56, 0x29, 0x03, 0x14, 0x0d, 0x43,
        0x22, 0x38, 0xd6, 0xd7, 0x8d, 0x28, 0x73, 0x70,   // blockLocatorHash1
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0a, 0x72, 0xd2, 0xe6, 0x63, 0x4a, 0x71, 0x6f,
        0x3c, 0x51, 0x92, 0x1e, 0xe4, 0x47, 0x4c, 0x25,
        0x33, 0x48, 0x0b, 0xa7, 0x44, 0xd8, 0xf7, 0x24]   // blockHashStop
    let expectedData = NSData(bytes:expectedBytes, length:expectedBytes.count)
    XCTAssertEqual(getBlocksMessage.data, expectedData)
  }

  func testGetBlocksMessageWithNoBlockHashStopEncoding() {
    let getBlocksMessage =
        GetBlocksMessage(protocolVersion:70001,
                         blockLocatorHashes:[blockLocatorHash0, blockLocatorHash1])
    let expectedBytes: [UInt8] = [
        0x71, 0x11, 0x01, 0x00,                           // 70001 (protocol version 70001)
        0x02,                                             // Number of block locator hashes (2)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x64, 0xe4, 0x24, 0x80, 0xf3, 0xae, 0x48,
        0x26, 0x64, 0xa9, 0xae, 0xbc, 0x72, 0xc4, 0xc6,
        0xa1, 0xf0, 0x9b, 0x50, 0x7c, 0x25, 0x73, 0x0b,   // blockLocatorHash0
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x15, 0x90, 0x8e, 0xd4, 0x38, 0xb4, 0xc7, 0xff,
        0x3f, 0xbc, 0x56, 0x29, 0x03, 0x14, 0x0d, 0x43,
        0x22, 0x38, 0xd6, 0xd7, 0x8d, 0x28, 0x73, 0x70,   // blockLocatorHash1
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]   // blockHashStop
    let expectedData = NSData(bytes:expectedBytes, length:expectedBytes.count)
    XCTAssertEqual(getBlocksMessage.data, expectedData)
  }
}
