//
//  Post.m
//  SmartLock
//
//  Created by csis on 16/4/18.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "Post.h"





@implementation Post

-(void)setDelegate:(id)newDelegate
{
    delegate = newDelegate;
}


-(void)PostAPI:(NSString*)urlString  withParams:(NSDictionary*)parameters
{
        id successHandler = ^(NSURLSessionDataTask *task, id responseObject) {
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
            NSLog(@"请求成功，服务器返回的信息%@",result);
            NSData *data = [result   dataUsingEncoding:NSUTF8StringEncoding];
    
            NSError *error;
//IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//    
//            NSDictionary *errorInfo = [info objectForKey:@"error"];
//
//    
//            NSDictionary *msuccessInfo = [info objectForKey:@"success"];
//            NSLog(@"请求成功，选择跳转页面");
//            NSString *type = @"1";
            //[self performSegueWithIdentifier:@"approve" sender:sender];
            //[self performSegueWithIdentifier:@"apply" sender:sender];
    
    
        };
    
    
        id failHandler = ^(NSURLSessionDataTask *task, NSError * error) {
            NSLog(@"请求失败,服务器返回的信息%@",error);
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知"
               message:@"服务已关闭，请联系管理员" preferredStyle:  UIAlertControllerStyleAlert];
    
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
    
        };
    
    
//请求的参数：即向服务器发送的参数，比如登录QQ时的账号和密码
//        NSDictionary *parameters = @{@"phone":self.uidTextField.text,
//                                     @"password":self.pwdTextField.text
//                                     };
//请求的网址：即请求的接口
//NSString *urlString = @"https://www.smartlock.top/v0/login";
    
        //请求的manager
        AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
        //进行POST请求
        managers.requestSerializer = [AFHTTPRequestSerializer serializer];
        managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        [managers POST:urlString parameters:parameters  success:successHandler  failure:failHandler];

}

@end
