//
//  Post.m
//  SmartLock
//
//  Created by csis on 16/4/18.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "GetDelegate.h"

@implementation Get
@synthesize data,error;


-(void)setDelegate:(id)newDelegate
{
    delegate = newDelegate;
}

//参数示例
//NSDictionary *parameters = @{@"phone":"123",@"password":"123456"};
//NSString *urlString = @"https://www.smartlock.top/v0/login";
-(void)getUrl:(NSString*)urlString  withParams:(NSDictionary*)parameters
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
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    [managers setSecurityPolicy:securityPolicy];
    
    managers.requestSerializer = [AFHTTPRequestSerializer serializer];
    managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    //managers.requestSerializer = [AFJSONRequestSerializer serializer];
    //managers.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
//    managers.responseSerializer.acceptableContentTypes = [managers.responseSerializer.acceptableContentTypes setByAddingObject:@"text/javascript"];
//    managers.responseSerializer.acceptableContentTypes = [managers.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    managers.responseSerializer = [AFJSONResponseSerializer serializer];
    managers.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/javascript"];
//    managers.requestSerializer.timeoutInterval = 30;
    //注意：默认的Response为json数据
    //[managers setResponseSerializer:[AFXMLParserResponseSerializer new]];
    //managers.responseSerializer = [AFHTTPResponseSerializer serializer];//使用这个将得到的是NSData
    //managers.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain; charset=utf-8"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    //managers.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    
//    managers.requestSerializer = [AFHTTPRequestSerializer serializer];
//    managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    [managers GET:urlString parameters:parameters  success:successHandler  failure:failHandler];
    
}


@end
