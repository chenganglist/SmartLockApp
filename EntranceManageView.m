//
//  EntranceManageViewViewController.m
//  SmartLock
//
//  Created by csis on 16/4/25.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "EntranceManageView.h"

@interface EntranceManageView ()

@end

@implementation EntranceManageView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)keyManageButtonPressed:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"电子钥匙管理";
    vc.handleType = KEYMANAGEMENT;
}


-(IBAction)localLogButtonPressed:(id)sender{
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"本地日志管理";
    vc.handleType = LOCALLOG;
}


-(IBAction)rightsManageButtonPressed:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"钥匙权限管理";
    vc.handleType = KEYRIGHT;

}


-(IBAction)openDoorButtonPressed:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"手机APP开门";
    vc.handleType = APPDOOR;

}


@end
