//
//  WorkDetailView.m
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "WorkDetailView.h"
static int userType; //0-管理员，1-工程师

@interface WorkDetailView ()

@end

@implementation WorkDetailView
@synthesize  workTable,workData,datalist,typelist
,keylist,classifyType,operateDescription,approveButton,rejectButton;

-(IBAction)approveButtonPressed:(id)sender
{
    
    if(userType == 1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有审批权限" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alertController animated:true completion:nil];
    }else
    {
        Post* post = [[Post alloc] init];
        NSDictionary* userInfo = [UserInfoView getUserInfo];
        NSDictionary* tokenInfo = [UserInfoView getTokenInfo];
        
        NSDictionary *parameters =
        @{@"operatorName":userInfo[@"username"],
          @"accessToken":tokenInfo[@"accessToken"],
          @"taskID":workData[@"taskID"],
          @"applicationStatus":@"approve",
          @"reason":self.operateDescription.text
        };
        
        NSString *urlString = @"https://www.smartlock.top/v0/taskAuthenticate";
        [post setDelegate:self];
        [post postUrl:urlString withParams:parameters];
    }
}

-(IBAction)rejectButtonPressed:(id)sender
{
    
    if(userType == 1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有审批权限" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alertController animated:true completion:nil];
    }else
    {
        Post* post = [[Post alloc] init];
        NSDictionary* userInfo = [UserInfoView getUserInfo];
        NSDictionary* tokenInfo = [UserInfoView getTokenInfo];
        
        NSDictionary *parameters =
          @{@"operatorName":userInfo[@"username"],
            @"accessToken":tokenInfo[@"accessToken"],
            @"taskID":workData[@"taskID"],
            @"applicationStatus":@"reject",
            @"reason":self.operateDescription.text
        };
        
        NSString *urlString = @"https://www.smartlock.top/v0/taskAuthenticate";
        [post setDelegate:self];
        [post postUrl:urlString withParams:parameters];
    }
}


//工单审批失败
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


//工单审批成功
-(void)updateUI:(NSDictionary*)data
{
    NSLog(@"UpdateUI %@",data);
    NSDictionary* success = data[@"success"];
    
    if(success!=nil)
    {
        //初始化提示框；
        NSData *datas =  [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString *data2String = [[NSString alloc]initWithData:datas encoding:NSUTF8StringEncoding];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
       message:data2String preferredStyle: UIAlertControllerStyleAlert];
        
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



+(void)setUserType:(int)type
{
    userType = type;
}

+(int)getUserType
{
    return userType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
    
    NSMutableArray *type = [[NSMutableArray alloc] initWithObjects:@"申请人", @"工单ID",@"申请人公司", @"申请人电话", @"作业类型",@"作业描述",
        @"电子钥匙ID",@"作业开始时间",@"作业结束时间",@"开门次数",nil];

    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:
(workData[@"applicantName"]==nil)?@"未定义":workData[@"applicantName"],
(workData[@"taskID"]==nil)?@"未定义":workData[@"taskID"],
(workData[@"applicantCompany"]==nil)?@"未定义":workData[@"applicantCompany"],
(workData[@"applicantPhone"]==nil)?@"未定义":workData[@"applicantPhone"],
(workData[@"applicationType"]==nil)?@"未定义":workData[@"applicationType"],
(workData[@"applyDescription"]==nil)?@"未定义":workData[@"applyDescription"],
(workData[@"applicantKeyID"]==nil)?@"未定义":workData[@"applicantKeyID"],
(workData[@"taskStartTime"]==nil)?@"未定义":workData[@"taskStartTime"],
(workData[@"taskEndTime"]==nil)?@"未定义":workData[@"taskEndTime"],
(workData[@"taskTimes"]==nil)?@"未定义":workData[@"taskTimes"],nil];
    
    self.datalist = data;
    self.typelist = type;
    
    self.keylist = [[NSMutableArray alloc] initWithObjects:@"applicantName",
                    @"taskID",
                    @"applicantCompany", @"applicantPhone",
                    @"applicationType", @"applyDescription",
                    @"applicantKeyID", @"taskStartTime",
                    @"taskEndTime",@"taskTimes",nil];
    
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.workTable.contentSize = CGSizeMake(0,1000);
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.typelist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.typelist objectAtIndex:row];
    cell.detailTextLabel.text = [self.datalist objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowString = [self.typelist objectAtIndex:[indexPath row]];
    NSString *dataString = [self.datalist objectAtIndex:[indexPath row]];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:rowString message:dataString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }
    ]];

    //弹出提示框；
    [self presentViewController:alertController animated:true completion:nil];
    
}


@end
