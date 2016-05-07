//
//  APPDoorCommunication.h
//  SmartLock
//
//  Created by csis on 16/5/7.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface APPDoorCommunication : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * centralManager;
    CBPeripheral * connectPeripheral;
    CBCharacteristic * writeCharacteristic;
    
    NSString* bluetoothName;
    UITextView *tvRecv;
}

@property (nonatomic, strong) NSString* bluetoothName;
@property (nonatomic, strong) CBCentralManager * centralManager;
@property (nonatomic, strong) CBPeripheral * connectPeripheral;
@property (nonatomic, strong) CBCharacteristic * writeCharacteristic;


@property (strong, nonatomic) IBOutlet UITextView *tvRecv;

-(IBAction)appOpenDoorBtPressed:(id)sender;
-(IBAction)appQueryLockStatusBtPressed:(id)sender;
-(IBAction)appLeaveStationBtPressed:(id)sender;
-(IBAction)appBuildStationBtPressed:(id)sender;

@end
