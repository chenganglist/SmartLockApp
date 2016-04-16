//
//  CharacteristicViewController.m
//  SmartLock
//
//  Created by csis on 16/4/16.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "CharacteristicViewController.h"
#define channelOnCharacteristicView @"CharacteristicView"

@interface CharacteristicViewController ()

@end

@implementation CharacteristicViewController

@synthesize sendButton = _sendButton;
@synthesize receiveTextView = _receiveTextView;
@synthesize sendTextFiled = _sendTextFiled;
@synthesize receiveButton = _receiveButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    // Do any additional setup after loading the view from its nib.
    //初始化数据
    sect = [NSMutableArray arrayWithObjects:@"read value",@"write value",@"desc",@"properties", nil];
    readValueArray = [[NSMutableArray alloc]init];
    descriptors = [[NSMutableArray alloc]init];
    //配置ble委托
    [self babyDelegate];
    //读取服务
    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)babyDelegate{
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        NSLog(@"读取characteristics的委托: %@",characteristics);
    }];
    
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            //            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            NSLog(@"characteristics的descriptors的委托: %@",d);
        }
    }];
    
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        for (int i =0 ; i<descriptors.count; i++) {
            if (descriptors[i]==descriptor) {
                
                //                NSString *valueStr = [[NSString alloc]initWithData:descriptor.value encoding:NSUTF8StringEncoding];
                NSLog(@"%@",descriptor.value);
            }
        }
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
    
}



//写一个值
-(void)writeValue{
    //    int i = 1;
    Byte b = 0Xff;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}




//订阅一个值
-(void)setNotifiy:(id)sender{
    
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        NSLog(@"peripheral已经断开连接，请重新连接");
        return;
    }
    if (self.characteristic.properties & CBCharacteristicPropertyNotify ||  self.characteristic.properties & CBCharacteristicPropertyIndicate) {
        
        if(self.characteristic.isNotifying) {
            [baby cancelNotify:self.currPeripheral characteristic:self.characteristic];
        }else{
            [baby notify:self.currPeripheral
          characteristic:self.characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       NSLog(@"notify block");
                       //                NSLog(@"new value %@",characteristics.value);
                       //                [self insertReadValues:characteristics];
                   }];
        }
    }
    else{
        NSLog(@"这个characteristic没有nofity的权限");
        return;
    }
}


-(IBAction)sendButtonPressed:(id)sender{
    [sendTextFiled resignFirstResponder];
    [receiveTextView resignFirstResponder];
    
    [self writeValue];
    NSLog(@"这个sendButtonPressed");
}


-(IBAction)receiveButtonPressed:(id)sender{
    [sendTextFiled resignFirstResponder];
    [receiveTextView resignFirstResponder];
    NSLog(@"这个receiveButtonPressed");
}




@end
