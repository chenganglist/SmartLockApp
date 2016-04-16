//
//  CharacteristicViewController.h
//  SmartLock
//
//  Created by csis on 16/4/16.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"


@interface CharacteristicViewController : UIViewController{
@public
    BabyBluetooth *baby;
    NSMutableArray *sect;
    __block  NSMutableArray *readValueArray;
    __block  NSMutableArray *descriptors;
    
    UIButton *sendButton;
    UIButton *receiveButton;
    UITextField *sendTextFiled;
    UITextView *receiveTextView;
    
}

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@property(nonatomic,retain) IBOutlet UIButton *sendButton;
@property(nonatomic,retain) IBOutlet UIButton *receiveButton;
@property(strong, nonatomic) IBOutlet UITextField *sendTextFiled;
@property(strong, nonatomic) IBOutlet UITextView *receiveTextView;


-(IBAction)sendButtonPressed:(id)sender;
-(IBAction)receiveButtonPressed:(id)sender;



@end
