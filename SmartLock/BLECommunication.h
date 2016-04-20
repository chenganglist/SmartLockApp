//
//  BLECommunication.h
//  SmartLock
//
//  Created by csis on 16/4/20.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLECommunication : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * centralManager;
    CBPeripheral * connectPeripheral;
    CBCharacteristic * writeCharacteristic;
}

@property (nonatomic, strong) CBCentralManager * centralManager;
@property (nonatomic, strong) CBPeripheral * connectPeripheral;
@property (nonatomic, strong) CBCharacteristic * writeCharacteristic;

@property(nonatomic,retain) IBOutlet UIButton *sendButton;
@property(strong, nonatomic) IBOutlet UITextField *sendTextFiled;
@property (weak, nonatomic) IBOutlet UITextView *tvRecv;

-(IBAction)sendButtonPressed:(id)sender;
@end
