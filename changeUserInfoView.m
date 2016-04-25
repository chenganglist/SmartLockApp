//
//  changeUserInfoView.m
//  SmartLock
//
//  Created by csis on 16/4/25.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "changeUserInfoView.h"

@interface changeUserInfoView ()

@end

@implementation changeUserInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    // Do any additional setup after loading the view from its nib.
    self.userInfoFiled.text = self.dataString;
}





-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(IBAction)saveUserChangeButtonPressed:(id)sender
{
    if([self.keyString isEqualToString:@"userType"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
           message:@"用户类型不可更改" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                          }]];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    
    Post* post = [[Post alloc] init];
    NSMutableDictionary* userInfo = [UserInfoView getUserInfo];
    NSMutableDictionary* tokenInfo = [UserInfoView getTokenInfo];
    NSDictionary *parameters =
    @{@"operatorName":userInfo[@"username"],
      @"accessToken":tokenInfo[@"accessToken"],
      @"originalName":userInfo[@"username"],
      self.keyString:self.userInfoFiled.text
      };
    NSString *urlString = @"https://www.smartlock.top/v0/updateUser";
    [post setDelegate:self];
    [post postUrl:urlString withParams:parameters];
}



//用户信息修改失败
-(void)alertUI:(NSError *)error
{
    //初始化提示框；
    NSString* info = [[NSString alloc] initWithFormat:@"错误：%@",error];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
               message:info preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//用户信息修改成功
-(void)updateUI:(NSDictionary*)data
{
    NSLog(@"UpdateUI %@",data);
    NSDictionary* success = data[@"success"];

    if(success!=nil)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
           message:@"信息修改成功" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
          {
              [self.datalist replaceObjectAtIndex:self.index withObject:self.userInfoFiled.text];
              [UserInfoView setDataList:self.datalist];
          }]];
        [self presentViewController:alert animated:true completion:nil];
        
    }else{
        //初始化提示框；
        NSData *datas =  [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
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
