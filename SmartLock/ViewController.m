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
static NSDictionary * successInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSDictionary*)getSuccessInfo{
    return successInfo;
}



-(IBAction)uidDidEndOnExit:(id)sender{
    [pwdTextField  becomeFirstResponder];
}


-(void)loginButtonPressed:(id)sender{


    [self performSegueWithIdentifier:@"approve" sender:sender];

}


@end




//    id successHandler = ^(NSURLSessionDataTask *task, id responseObject) {
//        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//
//        NSLog(@"请求成功，服务器返回的信息%@",result);
//        NSData *data = [result   dataUsingEncoding:NSUTF8StringEncoding];
//
//        NSError *error;
//        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//
//        NSDictionary *errorInfo = [info objectForKey:@"error"];
//        if( [errorInfo count] >0 ){
//            //初始化提示框；
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知"
//           message:@"用户名或密码错误" preferredStyle:  UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //点击按钮的响应事件；
//            }]];
//
//            //弹出提示框；
//            [self presentViewController:alert animated:true completion:nil];
//            return;
//        }
//
//        NSDictionary *msuccessInfo = [info objectForKey:@"success"];
//        successInfo = msuccessInfo;
//        NSDictionary *userInfo = [successInfo objectForKey:@"userInfo"];
//
//        NSLog(@"请求成功，选择跳转页面");
//
//        NSString* userType = [userInfo objectForKey:@"userType"];
//
//        NSString *type = @"1";
//
//
//        if([userType isEqualToString: type])
//        {
//            [self performSegueWithIdentifier:@"approve" sender:sender];
//        }else{
//            [self performSegueWithIdentifier:@"apply" sender:sender];
//        }
//
//        //[self performSegueWithIdentifier:@"approve" sender:sender];
//        //[self performSegueWithIdentifier:@"apply" sender:sender];
//
//
//    };
//
//
//    id failHandler = ^(NSURLSessionDataTask *task, NSError * error) {
//
//        NSLog(@"请求失败,服务器返回的信息%@",error);
//        //初始化提示框；
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知"
//           message:@"服务已关闭，请联系管理员" preferredStyle:  UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //点击按钮的响应事件；
//        }]];
//
//        //弹出提示框；
//        [self presentViewController:alert animated:true completion:nil];
//
//    };
//
//
//
//
//    //请求的参数：即向服务器发送的参数，比如登录QQ时的账号和密码
//    NSDictionary *parameters = @{@"phone":self.uidTextField.text,
//                                 @"password":self.pwdTextField.text
//                                 };
//    //请求的网址：即请求的接口
//    NSString *urlString = @"https://www.smartlock.top/v0/login";
//
//    //请求的manager
//    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
//    //进行POST请求
//    managers.requestSerializer = [AFHTTPRequestSerializer serializer];
//    managers.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    [managers POST:urlString parameters:parameters  success:successHandler  failure:failHandler];
