//
//  Post.m
//  SmartLock
//
//  Created by csis on 16/4/18.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "Post.h"

@implementation Post
@synthesize data,error;


-(void)setDelegate:(id)newDelegate
{
    delegate = newDelegate;
}


//参数示例
//NSDictionary *parameters = @{@"phone":"123",@"password":"123456"};
//NSString *urlString = @"https://www.smartlock.top/v0/login";
-(void)postUrl:(NSString*)urlString  withParams:(NSDictionary*)parameters
{

    id successHandler = ^(NSURLSessionDataTask *task, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject
                                    encoding:NSUTF8StringEncoding];
        NSLog(@"请求成功，服务器返回的信息: %@",result);
        NSData *originalData = [result   dataUsingEncoding:NSUTF8StringEncoding];

        NSError *errorInfo;
        if( errorInfo )
        {
            NSLog(@"解析失败,数据格式错误: %@",errorInfo);
            self.error = errorInfo;
            [delegate alertUI:errorInfo];
        }else
        {
            //解析出数据放到字典中
            self.data = [NSJSONSerialization JSONObjectWithData:originalData
                        options:NSJSONReadingMutableLeaves error:&errorInfo];
            NSLog(@"原始的字典数据: %@",data);
            [delegate updateUI:data];
        }
       
    };
    
    
    id failHandler = ^(NSURLSessionDataTask *task, NSError * errorInfo) {
        NSLog(@"请求失败,服务器返回的信息: %@",errorInfo);
        [delegate alertUI:errorInfo];
    };

    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.requestSerializer = [AFHTTPRequestSerializer serializer];
    managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    [managers POST:urlString parameters:parameters  success:successHandler  failure:failHandler];

}


@end
