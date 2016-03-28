//
//  BTManager.h
//  SCBlueToothKit
//
//  Created by 叔 陈 on 16/3/9.
//  Copyright © 2016年 叔 陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define NOTIFY_MTU 50

@interface BTManager : NSObject <CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>

// 主机Manager
@property (strong, nonatomic) CBCentralManager      *centralManager;

@property (copy, nonatomic) void (^receivedDataCallback)(NSMutableData *data);

@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *receivedData;

// 作为外部设备时的Manager
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;

+ (BTManager *)sharedInstance;

- (void)stopAdvertising;

- (void)startCentralServiceWithCallBack:(void (^)(NSData *receivedData))callBack;
- (void)startPeripheralService;
- (void)startCentralService;

- (void)stopScanning;

- (BOOL)isReceivingOrScanning;

- (void)sendData;
@end
