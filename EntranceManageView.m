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
    
    //浅蓝色
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:176/255.0 green:224/255.0 blue:230/255.0 alpha:1.0]];
    
    //浅灰色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:220/255.0 green:224/255.0 blue:230/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)keyManageButtonPressed:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    vc.handleType = KEYMANAGEMENT;
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"电子钥匙管理";
    
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


-(IBAction)appOpenDoorBtPressed:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    
    vc.handleType = APPOPENDOOR;
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"APP开门";


}


-(IBAction)heiZhimaDebug:(id)sender{
    
    KeyManagementView *vc = [[KeyManagementView alloc]initWithNibName:@"KeyManagementView" bundle:nil];
    vc.handleType = Heizhima;
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"蓝牙调试";


}


@end
