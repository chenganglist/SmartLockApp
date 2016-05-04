//
//  BLECommunication.m
//  SmartLock
//
//  Created by csis on 16/4/20.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "BLECommunication.h"
#import "CRC16.h"

NSMutableData *recvData;

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
    //NSString *str = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
    //NSString *str = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    Byte *recvByte = (Byte *)[characteristic.value  bytes];
    for(int i=0;i<[characteristic.value length];i++)
    {
        NSString *HexStr =
        [NSString stringWithFormat:@" %02x",recvByte[i]];//16进制数
        printf("recvByte[%d] = 0x%02x\n",i,recvByte[i]);
        self.tvRecv.text= [self.tvRecv.text stringByAppendingString:HexStr];
    }
    
    [recvData  appendData: characteristic.value];

    NSLog(@"receive: %@", recvData);
    //self.tvRecv.text= [self.tvRecv.text stringByAppendingString:str];
    
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
        //NSData *data = [MsgToArduino.text dataUsingEncoding:[NSString defaultCStringEncoding]];
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
    
    Byte s = second&0xff; //秒
    Byte m = minute&0xff; //分
    Byte h = hour&0xff; //时
    Byte Y = year&0xff; //年
    Byte M = month&0xff; //月
    Byte D = day&0xff; //日
    
    //S-M-H-Y-M-D
    Byte firstFrame[20] = {0x01,/*帧序号*/
        0x7E,0xFE,/*命令标志码*/
        s,m,h,Y,M,D,/*时间*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,0x69,/*手机号*/
        0 /*自动补全*/};
    
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:20];
    
    
    [self sendData:firstFrameData];
    //sleep(50);//设置成50ms等待下一次发送数据
    [NSThread sleepForTimeInterval:1];//设置成1s等待下一次发送数据
    
    
    Byte frame[36] = { 0x7E,0xFE,/*命令标志码*/
        s,m,h,Y,M,D,/*时间*/
        0x00,0x00,0x00,0x00,0x00, 0x55,0x20,0x88,0x38,0x69,/*手机号*/
        0,/*自动补全*/
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/*自动补全*/};
    
    uint16_t crc = CRC16(frame, 36);
    
    //提取校验位
    Byte crc1 = (crc&0xff00)>>2;
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
    Byte crc1 = (crc&0xff00)>>2;
    Byte crc2 = crc&0xff;
    
    Byte secondFrame[20] = {0x80,/*帧结尾*/
        0x69,/*手机号*/
        'L',0x11,0x22,0x33,0x44,0x55,0x66,0x77,/*LockID*/
        'K',0xff,0x11,0x22,0x33,0x44,0x55,0x66,/*KeyID*/
        crc1,crc2};
    
    
    NSData *secondFrameData = [[NSData alloc] initWithBytes:secondFrame length:20];
    
    [self sendData:secondFrameData];

}


-(IBAction)rightGivenButtonPressed:(id)sender
{
    Byte byte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
    NSData *data = [[NSData alloc] initWithBytes:byte length:24];
    
    [self sendData:data];
}


-(IBAction)historyButtonPressed:(id)sender
{
    Byte byte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
    NSData *data = [[NSData alloc] initWithBytes:byte length:24];
    
    [self sendData:data];
}


-(IBAction)builtStationButtonPressed:(id)sender
{
    Byte byte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
    NSData *data = [[NSData alloc] initWithBytes:byte length:24];
    
    [self sendData:data];
}

@end
