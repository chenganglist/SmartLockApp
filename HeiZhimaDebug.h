//
//  HeiZhimaDebug.h
//  SmartLock
//
//  Created by csis on 16/5/12.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AES128.h"

@interface HeiZhimaDebug : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * centralManager;
    CBPeripheral * connectPeripheral;
    CBCharacteristic * writeCharacteristic;
    CBCharacteristic * recvCharacteristic;
    
    NSString* bluetoothName;
    UITextView *tvRecv;
}

@property (nonatomic, strong) NSString* bluetoothName;
@property (nonatomic, strong) CBCentralManager * centralManager;
@property (nonatomic, strong) CBPeripheral * connectPeripheral;
@property (nonatomic, strong) CBCharacteristic * writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic * recvCharacteristic;

@property (strong, nonatomic) IBOutlet UITextView *tvRecv;

-(IBAction)heiZhimaGetInfo:(id)sender;

@end
