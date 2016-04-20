//
//  DoorSystemView.h
//  SmartLock
//
//  Created by csis on 16/4/20.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface DoorSystemView : UIViewController<UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>
{
    
    CBCentralManager * centralManager;
    NSMutableArray *peripheralsName;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;


-(IBAction)searchButtonPressed:(id)sender;

@end
