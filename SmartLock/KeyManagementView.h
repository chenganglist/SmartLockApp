//
//  DoorSystemView.h
//  SmartLock
//
//  Created by csis on 16/4/20.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "APPDoorCommunication.h"
#import "HeiZhimaDebug.h"

#define KEYMANAGEMENT 0
#define KEYRIGHT 1
#define Heizhima  2
#define LOCALLOG 3

@interface KeyManagementView : UIViewController<UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>
{
    
    CBCentralManager * centralManager;
    NSMutableArray *peripheralsName;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic) int handleType;
//0-电子钥匙管理  1-电子钥匙授权  2-手机APP开门  3-本地日志管理

-(IBAction)searchButtonPressed:(id)sender;

@end
