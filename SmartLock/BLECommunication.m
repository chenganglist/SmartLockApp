//
//  BLECommunication.m
//  SmartLock
//
//  Created by csis on 16/4/20.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "BLECommunication.h"
#import "CRC16.h"
#define TIMESYNC 0
#define QUERYLOCK 1
#define JUDGERIGHT 2
#define READHISTORY 3
#define BUILDSTATION 4

NSMutableData *recvData;
int commondType;
//因为接收的数据有标志位，去除自定义的标志
//int recvFrameCount;
//int sendFrameCount;
//为了调试的方便，采用延时发送数据，弃用全局数组，每次间隔1s
//Byte timeSyncFirstFrame[20],timeSyncLastFrame[20];
//Byte queryLockFirstFrame[20],queryLockLastFrame[20];
//Byte judgeRightFirstFrame[20],judgeRightSecondFrame[20],judgeRightLastFrame[20];
//Byte readHistoryFirstFrame[20],readHistoryLastFrame[20];
//Byte buildStationFirstFrame[20],buildStationLastFrame[20];
Byte timeSync_s,timeSync_m,timeSync_h,timeSync_Y,timeSync_M,timeSync_D;/*时间*/
Byte keyID[8];

@interface BLECommunication ()

@end

@implementation BLECommunication
@synthesize centralManager,connectPeripheral,
writeCharacteristic,bluetoothName;

@synthesize sendButton,tvRecv;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    recvData = [[NSMutableData alloc] init]; //初始化接收区
    
    //初始化蓝牙中心模式设备管理器
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}


-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            
        }
        
        if( (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) ==
           CBCharacteristicPropertyWriteWithoutResponse )
        {
            NSLog(@"写无回复");
            writeCharacteristic = characteristic;
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
        [recvData resetBytesInRange:NSMakeRange(0, recvData.length)];
        [recvData setLength:0];
        return;
    }
    
    [recvData  appendData: characteristic.value];

    Byte* curBytes = (Byte*)[[NSData dataWithData:recvData] bytes];
    NSLog(@"curRecvData length %d\n",[[NSData dataWithData:recvData] length]);
    for(int i=0;i<[[NSData dataWithData:recvData] length];i++)
    {
        NSLog(@"recvData[%d] = 0x%02x\n",i,curBytes[i]);
    }
    
    NSLog(@"\n\n");
    
    //操作失败，则弹出提示框：所有的操作失败都是返回6个字节
    if(curBytes[0]==0x80 &&
       curBytes[3]==0x97 &&
       [[NSData dataWithData:recvData] length]==6)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
           message:@"操作失败，请重新操作" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
        }]];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    
    //数据接收完毕，根据命令状态进行解析和处理
    Byte* allByte = (Byte *)[recvData bytes];
    switch(commondType)
    {
        case TIMESYNC:
        {
            if([[NSData dataWithData:recvData] length]!=40)
            {
                return;
            }
            int i = 11;
            for(;i<19;i++)
            {
                keyID[i-11] = allByte[i];
            }
            NSString* mKeyID = [NSString stringWithFormat:
            @"电子钥匙ID:%02x-%02x-%02x-%02x-%02x-%02x-%02x-%02x\n",
                keyID[0],keyID[1],keyID[2],keyID[3],
                keyID[4],keyID[5],keyID[6],keyID[7]];
            self.tvRecv.text= [self.tvRecv.text stringByAppendingString:mKeyID];

            NSString *HexStr =
            [NSString stringWithFormat:@"接收的时间 %02x分 %02x时 %02x年 %02x月 %02x日\n发送的时间 %02x分 %02x时 %02x年 %02x月 %02x日",
             allByte[21],/*M*/
             allByte[22]/*H*/,allByte[23],/*Y*/
             allByte[24],/*M*/allByte[25]/*D*/,
             timeSync_m,timeSync_h,timeSync_Y,timeSync_M,timeSync_D];
            self.tvRecv.text= [self.tvRecv.text stringByAppendingString:HexStr];
            NSString* timeInfo =[NSString stringWithFormat:@"对时成功，当前时间为:\n %02x年 %02x月 %02x日 %02x时 %02x分 ",
                timeSync_Y,timeSync_M,timeSync_D,timeSync_h,timeSync_m];
            if(
               allByte[21]!=timeSync_m ||
               allByte[22]!=timeSync_h ||
               allByte[23]!=timeSync_Y ||
               allByte[24]!=timeSync_M ||
               allByte[25]!=timeSync_D)
            {
                timeInfo = @"对时失败，请重新操作";
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
               message:timeInfo preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                              }]];
            [self presentViewController:alert animated:true completion:nil];
            break;
        }
        case QUERYLOCK:
        {
            if([[NSData dataWithData:recvData] length]!=40)
            {
                return;
            }
            NSString* statusString = @"";
            Byte status = allByte[34];//包含序号，在第34个字节
            statusString = [NSString stringWithFormat:
            @"门磁一状态：%d\n 锁舌一状态：%d\n 门磁二状态：%d\n 锁舌二状态：%d\n 有无门磁一：%d\n 有无锁舌一%d\n 有无门磁二：%d\n 有无锁舌二%d\n",
            status&0x01,(status>>1)&0x01,(status>>2)&0x01,
            (status>>3)&0x01,(status>>4)&0x01,
            (status>>5)&0x01,(status>>6)&0x01,(status>>7)&0x01];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                message:statusString preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                              }]];
            [self presentViewController:alert animated:true completion:nil];
            break;
        }
        case JUDGERIGHT:
        {
            if([[NSData dataWithData:recvData] length]!=6)
            {
                return;
            }
            if(allByte[3]==0x17)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                   message:@"鉴权成功" preferredStyle: UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                  }]];
                [self presentViewController:alert animated:true completion:nil];
            }
            break;
        }
        case READHISTORY:
        {
            
            break;
        }
        case BUILDSTATION:
        {
            
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




-(IBAction)timeSyncButtonPressed:(id)sender{

    //清空接收区数据
    self.tvRecv.text = @"对时开始：";
    [recvData resetBytesInRange:NSMakeRange(0, recvData.length)];
    [recvData setLength:0];
    
    //获取当前时间
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    int day = (int)[dateComponent day];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    
    //电脑端校验需要去除01 02 和 80等序号字节
    //timeSync_s,timeSync_m,timeSync_h,timeSync_Y,timeSync_M,timeSync_D
    timeSync_s = second%10 + ((second/10)%10)*16; //秒
    timeSync_m = minute%10 + ((minute/10)%10)*16; //分
    timeSync_h = hour%10 + ((hour/10)%10)*16; //时
    timeSync_Y = year%10 + ((year/10)%10)*16; //年
    timeSync_M = month%10 + ((month/10)%10)*16; //月
    timeSync_D = day%10 + ((day/10)%10)*16; //日
    
    //S-M-H-Y-M-D
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7E,0xFE,/*命令标志码*/
        timeSync_s,timeSync_m,timeSync_h,timeSync_Y,
        timeSync_M,timeSync_D,/*时间*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,0x69,/*手机号*/
        0 /*自动补全*/};

    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    
    
    [self sendData:firstFrameData];
    commondType = TIMESYNC;
    
    [NSThread sleepForTimeInterval:1];//设置成1s等待下一次发送数据
    
    Byte frame[36] = { 0x7E,0xFE,/*命令标志码*/
        timeSync_s,timeSync_m,timeSync_h,timeSync_Y,
        timeSync_M,timeSync_D,/*时间*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,0x69,/*手机号*/
        0,/*自动补全*/
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/*自动补全*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*最后一帧标志*/
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,/*自动补全*/
        crc1,crc2/*校验码*/};
    

    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
    
    
}


-(IBAction)queryLockStatusButtonPressed:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"查询锁状态：";
    [recvData resetBytesInRange:NSMakeRange(0, recvData.length)];
    [recvData setLength:0];
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x44,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38/*用户信息即手机号*/};
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    
    [self sendData:firstFrameData];
    commondType = QUERYLOCK;
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    
    Byte frame[36] = {0x7e,0x44,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,/*用户信息即手机号*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/
        crc1,crc2/*校验码*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];

}


-(IBAction)rightGivenButtonPressed:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"鉴权开始：";
    [recvData resetBytesInRange:NSMakeRange(0, recvData.length)];
    [recvData setLength:0];
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x17,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/
         'L' /*LockID*/
        };
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    commondType = JUDGERIGHT;
    [self sendData:firstFrameData];
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    //获取当前时间
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    int day = (int)[dateComponent day];
    int hour = (int)[dateComponent hour];

    //电脑端校验需要去除01 02 和 80等序号字节
    Byte h = hour%10 + ((hour/10)%10)*16; //时
    Byte Y = year%10 + ((year/10)%10)*16; //年
    Byte M = month%10 + ((month/10)%10)*16; //月
    Byte D = day%10 + ((day/10)%10)*16; //日

    Byte secondFrame[20] = {0x02,/*第二帧*/
        0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        Y,M,D,h,/*有效开始时间*/
        Y,M,D+1,h,/*有效终止时间*/
        0x05,/*有效开门次数*/
        0x00,0x00,0x00/*用户信息即手机号*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
    
    
    Byte frame[55] = {/*第一帧*/
        0x7e,0x17,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/
        'L' /*LockID*/,
        /*第二帧*/
        0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        0x16,0x05,0x10,0x10,/*有效开始时间*/
        0x16,0x05,0x12,0x20,/*有效终止时间*/
        0x05,/*有效开门次数*/
        0x00,0x00,0x00,/*用户信息即手机号*/
        /*结尾帧*/
        0x00,0x00,0x55,0x20,0x88,0x38,0x69,/*用户信息即手机号*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00/*自动补齐*/
};
    
    uint16_t crc = CRC16(frame, 55);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    Byte lastFrame[20] = {0x80,/*结尾帧*/
        0x00,0x00,0x55,0x20,0x88,0x38,0x69,/*用户信息即手机号*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*自动补齐*/
        crc1,crc2/*校验码*/};
    
    NSData *lastFrameData = [[NSData alloc] initWithBytes:lastFrame length:20];
    
    [self sendData:lastFrameData];
}


-(IBAction)historyButtonPressed:(id)sender
{
    self.tvRecv.text = @"查询历史记录：";
    //清空接收区数据
    [recvData resetBytesInRange:NSMakeRange(0, recvData.length)];
    [recvData setLength:0];
    
    //获取当前时间
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    int day = (int)[dateComponent day];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    
    //电脑端校验需要去除01 02 和 80等序号字节
    Byte s = second%10 + ((second/10)%10)*16; //秒
    Byte m = minute%10 + ((minute/10)%10)*16; //分
    Byte h = hour%10 + ((hour/10)%10)*16; //时
    Byte Y = year%10 + ((year/10)%10)*16; //年
    Byte M = month%10 + ((month/10)%10)*16; //月
    Byte D = day%10 + ((day/10)%10)*16; //日
    
    //S-M-H-Y-M-D
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x11,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/
        s/*请求时间*/};
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    commondType = READHISTORY;
    [self sendData:firstFrameData];
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    
    Byte frame[36] = {/*帧序号*/
        0x7e,0x11,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/
        s,/*请求时间*/
        /*帧结尾*/
        m,h,Y,M,D,/*请求时间*/
        0x01,/*序号*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*自动补全*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        m,h,Y,M,D,/*请求时间*/
        0x01,/*序号*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*自动补全*/
        crc1,crc2/*校验码*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
}


-(IBAction)builtStationButtonPressed:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"建站即修改平台码开始：";
    [recvData resetBytesInRange:NSMakeRange(0, recvData.length)];
    [recvData setLength:0];
    
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7e,0x4E,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38/*用户信息即手机号*/};
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    commondType = BUILDSTATION;
    [self sendData:firstFrameData];
    //设置成1s等待下一次发送数据
    [NSThread sleepForTimeInterval:1];
    
    
    Byte frame[36] = {0x7e,0x4E,/*命令标志码*/
        0x42,/*用户权限码*/
        0x01,/*城市码*/
        0x73,0x63,0x74,0x74,0x01,0x06, /*用户码即开锁密码*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,/*用户信息即手机号*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>8;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/
        crc1,crc2/*校验码*/};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];
}

@end
