//
//  ApplyWorkView.m
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "ApplyWorkView.h"

@interface ApplyWorkView ()

@end

@implementation ApplyWorkView
@synthesize  resetButton,commitButton,stationAddress;
@synthesize  workType,startTime,endTime,electronicKey;
@synthesize  workDescription,scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize= CGSizeMake(400,850);
    
    stationAddress.text = @"四川省成都市金牛区跃进村";
    workType.text = @"普通";
    startDate = [NSDate date];//获取当前时间，日期
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"startDateString:%@",startDateString);
    startTime.text = startDateString;
    
    
    NSTimeInterval interval = [startDate timeIntervalSince1970];
    long long int date = (long long int)interval+3600*4;
    NSLog(@"date\n %lld", (long long int)date); //1295322949
    
    //把秒数转化成yyyy-MM-dd hh:mm:ss格式
    endDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    NSLog(@"endDateString:%@",endDateString);
    
    endTime.text = endDateString;
    electronicKey.text = @"010002";
    workDescription.text = @"维修电表";


    
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)resetButtonPressed:(id)sender
{
    NSLog(@"resetButtonPressed");
    stationAddress.text = @"四川省成都市金牛区跃进村";
    workType.text = @"普通";
    startDate = [NSDate date];//获取当前时间，日期
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"startDateString:%@",startDateString);
    startTime.text = startDateString;
    
    
    NSTimeInterval interval = [startDate timeIntervalSince1970];
    long long int date = (long long int)interval+3600*4;
    NSLog(@"date\n %lld", (long long int)date); //1295322949
    
    //把秒数转化成yyyy-MM-dd hh:mm:ss格式
    endDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    NSLog(@"endDateString:%@",endDateString);
    
    endTime.text = endDateString;
    electronicKey.text = @"010002";
    workDescription.text = @"维修电表";
    

}


-(IBAction)commitButtonPressed:(id)sender
{
   NSLog(@"commitButtonPressed");
    Post* post = [[Post alloc] init];
    NSDictionary* userInfo = [UserInfoView getUserInfo];
    NSDictionary* tokenInfo = [UserInfoView getTokenInfo];

    NSDictionary *parameters =
    @{@"operatorName":userInfo[@"username"],
      @"accessToken":tokenInfo[@"accessToken"],
      @"stationAddress":self.stationAddress.text,
      @"applicantName":userInfo[@"username"],
      @"applicantCompany":userInfo[@"company"],
      @"applicantPhone":userInfo[@"phone"],
      @"applicantKeyID":self.electronicKey.text,
      @"applicationType":self.workType.text,
      @"applyDescription":self.workDescription.text,
      @"taskStartTime":[NSString stringWithFormat:@"%ld", (long)[startDate timeIntervalSince1970]],
      @"taskEndTime":[NSString stringWithFormat:@"%ld", (long)[endDate timeIntervalSince1970]],
      @"taskTimes":@"5"
      };
    
    NSString *urlString = @"https://www.smartlock.top/v0/taskRequest";
    [post setDelegate:self];
    [post postUrl:urlString withParams:parameters];
 
}


//工单申请失败
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


//工单申请成功
-(void)updateUI:(NSDictionary*)data
{
    NSLog(@"UpdateUI %@",data);
    NSDictionary* success = data[@"success"];
    
    if(success!=nil)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"工单申请成功" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              //Do something
                              
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
