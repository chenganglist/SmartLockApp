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

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
//    清空历史记录
//    NSArray *ma = nil;
//    [defaults setObject:ma forKey:@"keyHistory"];
//    [defaults synchronize];
    
    
    NSArray *AllRecord = [defaults objectForKey:@"keyHistory"];
    
    NSString* allRecordString = @"";
    
    int i = 1;
    for (NSString *item in AllRecord) {
        NSLog(@"%@",item);
        NSString* curItem = [NSString
            stringWithFormat:@"第%d条记录: %@",i,item];
        allRecordString =
        [allRecordString stringByAppendingString:curItem];
        i++;
    }
    
    //显示当次读取的所有历史记录
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"所有记录"
           message:allRecordString preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                      }]];
    [self presentViewController:alert animated:true completion:nil];

}


-(IBAction)rightsManageButtonPressed:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"钥匙权限管理";
    vc.handleType = KEYRIGHT;

}


-(IBAction)heiZhimaDebug:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"黑芝麻蓝牙调试";
    vc.handleType = Heizhima;

}


@end
