//
//  DoorSystemView.m
//  SmartLock
//
//  Created by csis on 16/4/20.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "DoorSystemView.h"

@interface DoorSystemView ()
   
@end

@implementation DoorSystemView

-(IBAction)searchButtonPressed:(id)sender
{
    //开始检测蓝牙
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //设置蓝牙检测时间
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
}

-(void) scanTimer:(NSTimer *)timer
{
    NSLog(@"5s时间已到，停止扫描蓝牙");
    [self.tableView reloadData];
    [centralManager stopScan];
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

//第二步：扫描蓝牙
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"step2 蓝牙中心 %@",central);
    NSLog(@"step2 扫描到的蓝牙: %@", peripheral);
    NSLog(@"－－－－－－－－－－－－－－－－－");
    NSLog(@"－－－－－－－－－－－－－－－－－");
    
    NSLog(@"Device name is: %@",peripheral.name);
    
    connectPeripheral = peripheral;
    connectPeripheral.delegate = self;
    
    [central connectPeripheral:connectPeripheral options:nil];
    NSLog(@"step2.1 蓝牙中心 %@",central);
    NSLog(@"step2.1 连接到的蓝牙: %@", peripheral);
    NSLog(@"－－－－－－－－－－－－－－－－－");
    NSLog(@"－－－－－－－－－－－－－－－－－");
    
    if(![peripherals containsObject:peripheral]) {
        [peripherals addObject:peripheral];
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






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化蓝牙中心模式设备管理器

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIViewController 方法



#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return peripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //peripheral的显示名称
    cell.textLabel.text = @"蓝牙名称";
    cell.detailTextLabel.text = peripheral.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    [centralManager stopScan];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//页面跳转
//    PeripheralViewContriller *vc = [[PeripheralViewContriller alloc]init];
//    vc.currPeripheral = [peripherals objectAtIndex:indexPath.row];
//    vc->baby = self->baby;
//    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
