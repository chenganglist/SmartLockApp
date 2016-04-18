//
//  ViewController.m
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize uidTextField = _uidTextField;
@synthesize pwdTextField = _pwdTextField;
@synthesize loginButton = _loginButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do something after loading the view
    
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)loginButtonPressed:(id)sender{

    Post* post = [[Post alloc] init];
    NSDictionary *parameters = @{@"phone":self.uidTextField.text,@"password":self.pwdTextField.text};
    NSString *urlString = @"https://www.smartlock.top/v0/login";
    [post setDelegate:self];
    [post postUrl:urlString withParams:parameters];
    
}

-(void)alertUI:(NSError *)error
{
    //初始化提示框；
    NSString* info = [[NSString alloc] initWithFormat:@"错误：%@",error];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
           message:info preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)updateUI:(NSDictionary*)data
{
    NSLog(@"UpdateUI %@",data);
    NSDictionary* success = data[@"success"];
    
    if(success!=nil)
    {
        NSDictionary* userInfo = success[@"userInfo"];
        NSString* userType = userInfo[@"userType"];
        if( [userType isEqualToString:@"1"] )
        {
           [self performSegueWithIdentifier:@"approve" sender:nil];
            NSLog(@"管理员登录");
        }else{
           [self performSegueWithIdentifier:@"approve" sender:nil];
            NSLog(@"工程师登录");
        }
        
    }else{
        //初始化提示框；
        NSData *datas =    [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString *data2String = [[NSString alloc]initWithData:datas encoding:NSUTF8StringEncoding];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                        message:data2String preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
}


@end

