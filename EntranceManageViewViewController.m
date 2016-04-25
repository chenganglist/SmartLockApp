//
//  EntranceManageViewViewController.m
//  SmartLock
//
//  Created by csis on 16/4/25.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "EntranceManageViewViewController.h"

@interface EntranceManageViewViewController ()

@end

@implementation EntranceManageViewViewController

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
    
}


-(IBAction)lockManageButtonPressed:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
   message:@"基站门锁管理" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];

   
    
}


-(IBAction)rightsManageButtonPressed:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
   message:@"电子钥匙授权管理" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];

    
}


-(IBAction)openDoorButtonPressed:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
   message:@"手机APP开门" preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];

    
}


@end
