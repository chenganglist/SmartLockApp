//
//  DoorSystemView.m
//  SmartLock
//
//  Created by csis on 16/4/20.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "KeyManagementView.h"
#import "BLECommunication.h"

@interface KeyManagementView ()
   
@end

@implementation KeyManagementView

-(IBAction)searchButtonPressed:(id)sender
{
    //开始检测蓝牙
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //设置蓝牙检测时间
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
}

-(void) scanTimer:(NSTimer *)timer
{
    NSLog(@"3s时间已到，停止扫描蓝牙");
    [self.tableView.delegate self];
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
    
    if(peripheral.name!=nil)
    {
        [self insertTableView:peripheral];
    }

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化蓝牙中心模式设备管理器
    peripheralsName = [NSMutableArray arrayWithCapacity:10];
    
    [self searchButtonPressed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIViewController 方法



#pragma mark -table委托 table delegate

//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral{
    if(![peripheralsName containsObject:peripheral.name]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripheralsName.count inSection:0];
        [indexPaths addObject:indexPath];
        [peripheralsName addObject:peripheral.name];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return peripheralsName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    NSString *bluetoothName = [peripheralsName objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }
    
    cell.textLabel.text = bluetoothName;
    cell.detailTextLabel.text = @"蓝牙名称";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    NSLog(@"跳转页面，停止扫描");
    [centralManager stopScan];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //页面跳转
    switch(self.handleType)
    {
        case KEYMANAGEMENT:
        {
            BLECommunication *vc = [[BLECommunication alloc]initWithNibName:@"BLECommunication" bundle:nil];
            
            vc.bluetoothName = [peripheralsName objectAtIndex:indexPath.row];
            
            NSLog(@"要打开的蓝牙为： %@",vc.bluetoothName);
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"蓝牙电子钥匙管理";
            break;
        }
        case APPOPENDOOR:
        {
            APPDoorCommunication *vc = [[APPDoorCommunication alloc]initWithNibName:@"APPDoorCommunication" bundle:nil];
            
            vc.bluetoothName = [peripheralsName objectAtIndex:indexPath.row];
            NSLog(@"要打开的蓝牙为： %@",vc.bluetoothName);
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"APP开门管理";
            break;
        }
        case Heizhima:
        {
            HeiZhimaDebug *vc = [[HeiZhimaDebug alloc]initWithNibName:@"HeiZhimaDebug" bundle:nil];
            
            vc.bluetoothName = [peripheralsName objectAtIndex:indexPath.row];
            
            NSLog(@"要打开的蓝牙为： %@",vc.bluetoothName);
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"黑芝麻蓝牙调试";
            break;
        }
        case LOCALLOG:
        {
            
            break;
        }
    }
}


@end
