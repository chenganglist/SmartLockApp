//
//  APPDoorCommunication.m
//  SmartLock
//
//  Created by csis on 16/5/7.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "APPDoorCommunication.h"
#import "CRC16.h"
#define APPOPENDOOR 0
#define APPLEAVEDOOR 1
#define APPQUERYLOCK 2
#define APPBUILDSTATION 3

NSMutableData *appRecvData;
int appCommondType;


@interface APPDoorCommunication ()

@end

@implementation APPDoorCommunication
@synthesize centralManager,connectPeripheral,
writeCharacteristic,tvRecv,bluetoothName;

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
    appRecvData = [[NSMutableData alloc] init]; //初始化接收区
    //初始化蓝牙中心模式设备管理器
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

//第一步：检测蓝牙是否打开，如果打开，则开始扫描外设
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state != CBCentralManagerStatePoweredOn )
    {
        NSLog(@"蓝牙未打开,请打开蓝牙");
        return;
    }
    
    NSLog(@"step1 蓝牙中心 %@",central);
    NSLog(@"－－－－－－－－－－－－－－－－－");
    NSLog(@"－－－－－－－－－－－－－－－－－");
    
    [centralManager scanForPeripheralsWithServices:nil options:nil];
    
}

//第二步：扫描蓝牙－并连接蓝牙：只需要connectPeripheral
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"step2 蓝牙中心 %@",central);
    NSLog(@"step2 扫描到的蓝牙: %@", peripheral);
    NSLog(@"－－－－－－－－－－－－－－－－－");
    NSLog(@"－－－－－－－－－－－－－－－－－");
    
    if([peripheral.name isEqualToString:bluetoothName]){
        connectPeripheral = peripheral;
        connectPeripheral.delegate = self;
        //连接蓝牙
        [central connectPeripheral:connectPeripheral options:nil];
        NSLog(@"step2.1 蓝牙中心 %@",central);
        NSLog(@"step2.1 连接到的蓝牙: %@", peripheral);
        NSLog(@"－－－－－－－－－－－－－－－－－");
        NSLog(@"－－－－－－－－－－－－－－－－－");
        
        [central stopScan];
    }
    
}


//第三步：发现connectPeripheral中的services
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    //查找外设中编号为A001的service
    //NSArray *arr = [[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:@"A001"], nil];
    //查找外设中的所有service
    NSArray *arr = [[NSArray alloc] init];
    
    [peripheral discoverServices:arr];
    NSLog(@"step3 蓝牙中心 %@",central);
    NSLog(@"step3 连接到的蓝牙: %@", peripheral);
    NSLog(@"－－－－－－－－－－－－－－－－－");
    NSLog(@"－－－－－－－－－－－－－－－－－");
    
}


//第四步：列出所有的service，并列出各自包含的characteristic
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for(CBService* service in peripheral.services)
    {
        NSLog(@"step4 连接到的蓝牙: %@", peripheral);
        NSLog(@"step4 当前蓝牙的services: %@",service);
        NSLog(@"－－－－－－－－－－－－－－－－－");
        NSLog(@"－－－－－－－－－－－－－－－－－");
        
        [connectPeripheral discoverCharacteristics:nil forService:service];
    }
}



//第五步：列出所有的characteristic
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    for( CBCharacteristic* characteristic in service.characteristics){
        
        //如果收到peripheral发送的数据，将触发第六步
        NSLog(@"step5 连接到的蓝牙: %@", peripheral);
        NSLog(@"step5 当前蓝牙的services: %@",service);
        NSLog(@"step5 当前服务的characteristics: %@",characteristic);
        NSLog(@"－－－－－－－－－－－－－－－－－");
        NSLog(@"－－－－－－－－－－－－－－－－－");
        
        if( (characteristic.properties & CBCharacteristicPropertyNotify)
           == CBCharacteristicPropertyNotify )
        {
            NSLog(@"可通知");
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            writeCharacteristic = characteristic;
        }
        
        if( (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) ==
           CBCharacteristicPropertyWriteWithoutResponse )
        {
            NSLog(@"写无回复");
        }
        
        if( (characteristic.properties & CBCharacteristicPropertyRead) ==
           CBCharacteristicPropertyRead )
        {
            NSLog(@"可读");
        }
        
    }
}



//第六步：自动接收数据--经测试，只能通过通知的方式接收数据
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    Byte *recvByte = (Byte *)[characteristic.value  bytes];
    if(recvByte[0]==0xaa)
    {
        //清空接收区数据
        [appRecvData resetBytesInRange:NSMakeRange(0, appRecvData.length)];
        [appRecvData setLength:0];
        return;
    }
    
    [appRecvData  appendData: characteristic.value];
    
    Byte* curBytes = (Byte*)[[NSData dataWithData:appRecvData] bytes];
    NSLog(@"curappRecvData length %lu\n",(unsigned long)[[NSData dataWithData:appRecvData] length]);
    for(int i=0;i<[[NSData dataWithData:appRecvData] length];i++)
    {
        NSLog(@"appRecvData[%d] = 0x%02x\n",i,curBytes[i]);
    }
    
    NSLog(@"\n\n");
    

    //数据接收完毕，根据命令状态进行解析和处理
    Byte* allByte = (Byte *)[appRecvData bytes];
    switch(appCommondType)
    {
        case APPOPENDOOR:
        {
            if([[NSData dataWithData:appRecvData] length]!=6)
            {
                return;
            }
            
            self.tvRecv.text= [self.tvRecv.text
                stringByAppendingString:
                [NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x",allByte[0],allByte[1],allByte[2],allByte[3],
                 allByte[4],allByte[5]]];
            
            NSString* statusString = @"开锁失败，请重新操作";
            if(allByte[3]==0x52)
            {
                statusString = @"开锁成功，请查看锁状态";
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                message:statusString preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                              }]];
            [self presentViewController:alert animated:true completion:nil];
            break;
        }
        case APPLEAVEDOOR:
        {
            
            if([[NSData dataWithData:appRecvData] length]!=6)
            {
                return;
            }
            self.tvRecv.text= [self.tvRecv.text
                               stringByAppendingString:
                               [NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x",allByte[0],allByte[1],allByte[2],allByte[3],
                                allByte[4],allByte[5]]];
            
            NSString* statusString = @"关门失败，请重新操作";
            if(allByte[3]==0x13)
            {
                statusString = @"关门成功，请查看锁状态";
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
               message:statusString preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                              }]];
            [self presentViewController:alert animated:true completion:nil];
            break;
        }
        case APPQUERYLOCK:
        {
            if([[NSData dataWithData:appRecvData] length]!=6)
            {
                return;
            }
            self.tvRecv.text= [self.tvRecv.text
                               stringByAppendingString:
                               [NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x",allByte[0],allByte[1],allByte[2],allByte[3],
                                allByte[4],allByte[5]]];
            
            NSString* statusString = @"";
            Byte status = allByte[3];//包含序号，在第4个字节
            statusString = [NSString stringWithFormat:
                            @"门磁一状态：%d\n 锁舌一状态：%d\n 门磁二状态：%d\n 锁舌二状态：%d\n 有无门磁一：%d\n 有无锁舌一%d\n 有无门磁二：%d\n 有无锁舌二%d\n",
                            status&0x01,(status>>1)&0x01,(status>>2)&0x01,
                            (status>>3)&0x01,(status>>4)&0x01,
                            (status>>5)&0x01,(status>>6)&0x01,(status>>7)&0x01];
            if(allByte[3]==0xFF)
            {
                statusString = @"查询失败，请重新操作";
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                message:statusString preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                              }]];
            [self presentViewController:alert animated:true completion:nil];
            
            break;
        }
        case APPBUILDSTATION:
        {
            
            if([[NSData dataWithData:appRecvData] length]!=12)
            {
                return;
            }
            
            self.tvRecv.text= [self.tvRecv.text
                               stringByAppendingString:
                               [NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",allByte[0],allByte[1],allByte[2],allByte[3],
                                allByte[4],allByte[5],
                                allByte[6],allByte[7],allByte[8],allByte[9],
                                allByte[10],allByte[11]]];
            
            NSString* statusString = @"新建站失败，请重新操作";
            if(allByte[3]==0x1E && allByte[9]==0x5e)
            {
                statusString = @"新建站成功，开门码已修改";
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
               message:statusString preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                              }]];
            [self presentViewController:alert animated:true completion:nil];
            break;
        }
            
    }
}



//第七步：发送数据
-(void)sendData:(NSData*)data
{
    if(data.length > 20)
    {
        int i = 0;
        while ((i + 1) * 20 <= data.length) {
            NSData *dataSend = [data subdataWithRange:NSMakeRange(i * 20, 20)];
            [connectPeripheral writeValue:dataSend forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            i++;
        }
        i = data.length % 20;
        if(i > 0)
        {
            NSData *dataSend = [data subdataWithRange:NSMakeRange(data.length - i, i)];
            [connectPeripheral writeValue:dataSend forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
        
    }else
    {
        [connectPeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        
        char buffer[20] = {
            ' ', ' ', ' ', ' ', ' ',
            ' ', ' ', ' ', ' ', ' ',
            ' ', ' ', ' ', ' ', ' ',
            ' ', ' ', ' ', ' ', ' ',};
        NSData* restData = [NSData dataWithBytes:buffer length:(20-data.length)];
        
        [connectPeripheral writeValue:restData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)appOpenDoorBtPressed:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"手机APP开门：";
    [appRecvData resetBytesInRange:NSMakeRange(0, appRecvData.length)];
    [appRecvData setLength:0];
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x42,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38/*用户信息即手机号*/};
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    
    [self sendData:firstFrameData];
    appCommondType = APPOPENDOOR;
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    
    Byte frame[36] = {0x7e,0x42,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,/*用户信息即手机号*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00/*自动补全*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*自动补全*/
        crc1,crc2/*校验码*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
    
}

-(IBAction)appQueryLockStatusBtPressed:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"查询锁状态：";
    [appRecvData resetBytesInRange:NSMakeRange(0, appRecvData.length)];
    [appRecvData setLength:0];
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x44,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38/*用户信息即手机号*/};
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    
    [self sendData:firstFrameData];
    appCommondType = APPQUERYLOCK;
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    
    Byte frame[36] = {0x7e,0x44,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,/*用户信息即手机号*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00/*自动补全*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*自动补全*/
        crc1,crc2/*校验码*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
}

-(IBAction)appLeaveStationBtPressed:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"APP关门离站：";
    [appRecvData resetBytesInRange:NSMakeRange(0, appRecvData.length)];
    [appRecvData setLength:0];
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x13,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38/*用户信息即手机号*/};
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    
    [self sendData:firstFrameData];
    appCommondType = APPLEAVEDOOR;
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    
    Byte frame[36] = {0x7e,0x13,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,/*用户信息即手机号*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00/*自动补全*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*自动补全*/
        crc1,crc2/*校验码*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
}

-(IBAction)appBuildStationBtPressed:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"新建站即修改基站信息：";
    [appRecvData resetBytesInRange:NSMakeRange(0, appRecvData.length)];
    [appRecvData setLength:0];
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x1e,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38/*用户信息即手机号*/};
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    
    [self sendData:firstFrameData];
    appCommondType = APPBUILDSTATION;
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    
    Byte frame[36] = {0x7e,0x1e,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,/*用户信息即手机号*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00/*自动补全*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*自动补全*/
        crc1,crc2/*校验码*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
}

@end
