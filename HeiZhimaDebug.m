//
//  APPDoorCommunication.m
//  SmartLock
//
//  Created by csis on 16/5/7.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "HeiZhimaDebug.h"
#import "CRC16.h"
#define HEIZHIMAGETINFO 0
#define APPLEAVEDOOR 1
#define APPQUERYLOCK 2
#define APPBUILDSTATION 3

NSMutableData *zhimaRecvData;
int zhimaCommondType;


@interface HeiZhimaDebug ()

@end

@implementation HeiZhimaDebug
@synthesize centralManager,connectPeripheral,
writeCharacteristic,tvRecv,bluetoothName,recvCharacteristic;

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
    zhimaRecvData = [[NSMutableData alloc] init]; //初始化接收区
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
            if(recvCharacteristic==nil)
            {
                recvCharacteristic = characteristic;
            }
        }
        
        if( (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) ==
           CBCharacteristicPropertyWriteWithoutResponse )
        {
            NSLog(@"写无回复");
            if(writeCharacteristic==nil)
            {
                writeCharacteristic = characteristic;
            }
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
        [zhimaRecvData resetBytesInRange:NSMakeRange(0, zhimaRecvData.length)];
        [zhimaRecvData setLength:0];
        return;
    }
    
    [zhimaRecvData  appendData: characteristic.value];
    
    Byte* curBytes = (Byte*)[[NSData dataWithData:zhimaRecvData] bytes];
    NSLog(@"curzhimaRecvData length %lu\n",(unsigned long)[[NSData dataWithData:zhimaRecvData] length]);
    for(int i=0;i<[[NSData dataWithData:zhimaRecvData] length];i++)
    {
        NSLog(@"zhimaRecvData[%d] = 0x%02x\n",i,curBytes[i]);
    }
    
    NSLog(@"\n\n");
    
    
    //数据接收完毕，根据命令状态进行解析和处理
    Byte* allByte = (Byte *)[zhimaRecvData bytes];
    switch(zhimaCommondType)
    {
        case HEIZHIMAGETINFO:
        {
            if([[NSData dataWithData:zhimaRecvData] length]!=9)
            {
                return;
            }
            
            self.tvRecv.text= [self.tvRecv.text
                               stringByAppendingString:
                               [NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x",allByte[0],allByte[1],allByte[2],allByte[3],
                                allByte[4],allByte[5],allByte[6],
                                allByte[7],allByte[8]]];
            
            NSString* statusString = [NSString stringWithFormat:
                                      @"获取钥匙信息为：\n %02x %02x %02x %02x %02x %02x %02x %02x %02x",allByte[0],allByte[1],allByte[2],
                                      allByte[3],allByte[4],allByte[5],allByte[6],
                                      allByte[7],allByte[8]];
            
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
    if(writeCharacteristic==nil)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"蓝牙尚未连接成功，请再等待几秒，或返回搜索界面重连" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                          }]];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
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
        
//黑芝麻不需要发送20帧字节，只需要保证每帧字节在20个以下
//        char buffer[20] = {
//            ' ', ' ', ' ', ' ', ' ',
//            ' ', ' ', ' ', ' ', ' ',
//            ' ', ' ', ' ', ' ', ' ',
//            ' ', ' ', ' ', ' ', ' ',};
//        NSData* restData = [NSData dataWithBytes:buffer length:(20-data.length)];
//        
//        [connectPeripheral writeValue:restData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)heiZhimaGetInfo:(id)sender
{
    //清空接收区数据
    self.tvRecv.text = @"获取钥匙信息：";
    [zhimaRecvData resetBytesInRange:NSMakeRange(0, zhimaRecvData.length)];
    [zhimaRecvData setLength:0];
    
    Byte realFrame[16] = { 0x00/*帧数据长度*/,0x42/*帧命令*/,/*没有帧数据*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,/*自动填充数据*/0x42};

    Byte firstFrame[38] = {0x55/*同步字段*/,0x20/*总长度，不包括前3个字节和总校验和*/,0xfe/*传输标记*/,
        
        /*明文帧数据，16的整数倍*/
        0x00/*帧数据长度*/,0x42/*帧命令*/,/*没有帧数据*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,/*帧数据自动填充数据*/0x42,
        
        /*填充数据，长度保证为16的整数倍*/
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        /*总校验和*/
        0x00
    };
    for(int i=0;i<37;i++)
    {
        firstFrame[37] += firstFrame[i];
    }
    
    NSData *firstFrameData = [[NSData alloc] initWithBytes:firstFrame length:38];
    
    [self sendData:firstFrameData];
    zhimaCommondType = HEIZHIMAGETINFO;
    
    NSLog(@"发送帧数据");
}


@end
