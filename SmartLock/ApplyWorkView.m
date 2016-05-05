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
@synthesize  workType,startTimeButton,endTimeButton,electronicKey;
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
    
    [startTimeButton setTitle:startDateString forState:UIControlStateNormal];// 添加文字

    NSTimeInterval interval = [startDate timeIntervalSince1970];
    long long int date = (long long int)interval+3600*4;
    NSLog(@"date\n %lld", (long long int)date); //1295322949
    
    //把秒数转化成yyyy-MM-dd hh:mm:ss格式
    endDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    NSLog(@"endDateString:%@",endDateString);
    
    [endTimeButton setTitle:endDateString forState:UIControlStateNormal];// 添加文字
    electronicKey.text = @"010000";
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

-(IBAction)startTimeLablePressed:(id)sender
{
    NSLog(@"开始时间弹框");//startDate

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, alert.view.frame.size.width, 80)];
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    //zh_CN
    //[datePicker setLocale:[NSLocale systemLocale]];
//    NSLocale* curLocal = [NSLocale currentLocale];
//    NSLog(@" %@ ",[curLocal localeIdentifier]);
//    NSLog(@" %@ ",[curLocal localeIdentifier]);
//    NSLog(@" %@ ",[curLocal localeIdentifier]);
//    NSLog(@" %@ ",[curLocal localeIdentifier]);
//    NSLog(@" %@ ",[curLocal localeIdentifier]);
    

    
    [alert.view addSubview:datePicker];
    
    UIView *superView=datePicker.superview;
    //添加约束，使按钮在屏幕水平方向的中央
    NSLayoutConstraint *centerXContraint=[NSLayoutConstraint
                                          constraintWithItem:datePicker
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0f
                                          constant:0.0];
    //添加约束，使按钮在屏幕垂直方向的中央
    NSLayoutConstraint *centerYContraint=[NSLayoutConstraint
                                          constraintWithItem:datePicker
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                          attribute:NSLayoutAttributeCenterY
                                          multiplier:1.0f
                                          constant:0.0];
    //给button的父节点添加约束
    [superView addConstraints:@[centerXContraint,centerYContraint]];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        //获取NSDate
        startDate = datePicker.date;
        //求出当天的时间字符串
        
        //显示获取的NSDate
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        NSLocale *usLocale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        //zh_CN
//        dateFormatter.locale= usLocale;
        dateFormatter.locale= [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *startDateString = [dateFormatter stringFromDate:startDate];
        NSLog(@"startDateString:%@",startDateString);
        
        
        [startTimeButton setTitle:startDateString forState:UIControlStateNormal];// 添加文字

        NSLog(@"%@",startDate);
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {

    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
    
    
}

-(IBAction)endTimeLablePressed:(id)sender
{
    NSLog(@"结束时间弹框");//endDate
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert.view addSubview:datePicker];
    
    UIView *superView=datePicker.superview;
    //添加约束，使按钮在屏幕水平方向的中央
    NSLayoutConstraint *centerXContraint=[NSLayoutConstraint
                                          constraintWithItem:datePicker
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0f
                                          constant:0.0];
    //添加约束，使按钮在屏幕垂直方向的中央
    NSLayoutConstraint *centerYContraint=[NSLayoutConstraint
                                          constraintWithItem:datePicker
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                          attribute:NSLayoutAttributeCenterY
                                          multiplier:1.0f
                                          constant:0.0];
    //给button的父节点添加约束
    [superView addConstraints:@[centerXContraint,centerYContraint]];
    

    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
     {
         //获取NSDate
         endDate = datePicker.date;
         //求出当天的时间字符串
         
         
         //显示获取的NSDate
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//         NSLocale *usLocale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
//         dateFormatter.locale= usLocale;
         
        dateFormatter.locale= [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
         [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
         NSString *startDateString = [dateFormatter stringFromDate:endDate];
         NSLog(@"startDateString:%@",startDateString);
         
         
         [endTimeButton setTitle:startDateString forState:UIControlStateNormal];// 添加文字
         
         NSLog(@"%@",endDate);
         
     }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
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
    
    [startTimeButton setTitle:startDateString forState:UIControlStateNormal];// 添加文字
    
    
    NSTimeInterval interval = [startDate timeIntervalSince1970];
    long long int date = (long long int)interval+3600*4;
    NSLog(@"date\n %lld", (long long int)date); //1295322949
    
    //把秒数转化成yyyy-MM-dd hh:mm:ss格式
    endDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    NSLog(@"endDateString:%@",endDateString);
    
    [endTimeButton setTitle:endDateString forState:UIControlStateNormal];// 添加文字
    electronicKey.text = @"010000";
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
