//
//  ClassifyWorkView.m
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "ClassifyWorkView.h"

@interface ClassifyWorkView ()

@end

@implementation ClassifyWorkView
@synthesize datalist;
@synthesize workTable,classifyType;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch(classifyType)
    {
        //approve
        case 0:
        {
            Post* post = [[Post alloc] init];
            NSDictionary* userInfo = [UserInfoView getUserInfo];
            NSDictionary* tokenInfo = [UserInfoView getTokenInfo];
            //0管理员
            NSDictionary *parametersForManager = @{@"operatorName":userInfo[@"username"],
                @"accessToken":tokenInfo[@"accessToken"],
                @"approvalPerson":userInfo[@"username"],
                @"applicationStatus":@"approve"
                                         };
            //1工程师
            NSDictionary *parametersForWorker = @{@"operatorName":userInfo[@"username"],
               @"accessToken":tokenInfo[@"accessToken"],
               @"applicantName":userInfo[@"username"],
               @"applicationStatus":@"approve"
               };
            
            NSString *urlString = @"https://www.smartlock.top/v0/taskFetch";
            [post setDelegate:self];
            if([WorkDetailView getUserType] == 0)
            {
                [post postUrl:urlString withParams:parametersForManager];
            }else{
                [post postUrl:urlString withParams:parametersForWorker];
            }
            
            break;
        }
        //wait
        case 1:
        {
            Post* post = [[Post alloc] init];
            NSDictionary* userInfo = [UserInfoView getUserInfo];
            NSDictionary* tokenInfo = [UserInfoView getTokenInfo];
            //0管理员
            NSDictionary *parametersForManager = @{@"operatorName":userInfo[@"username"],
               @"accessToken":tokenInfo[@"accessToken"],
               @"approvalPerson":userInfo[@"username"],
               @"applicationStatus":@"pending"
               };
            //1工程师
            NSDictionary *parametersForWorker = @{@"operatorName":userInfo[@"username"],
                  @"accessToken":tokenInfo[@"accessToken"],
                  @"applicantName":userInfo[@"username"],
                  @"applicationStatus":@"pending"
                  };
            
            NSString *urlString = @"https://www.smartlock.top/v0/taskFetch";
            [post setDelegate:self];
            if([WorkDetailView getUserType] == 0)
            {
                [post postUrl:urlString withParams:parametersForManager];
            }else{
                [post postUrl:urlString withParams:parametersForWorker];
            }

            break;
        }
        //reject
        case 2:
        {
            Post* post = [[Post alloc] init];
            NSDictionary* userInfo = [UserInfoView getUserInfo];
            NSDictionary* tokenInfo = [UserInfoView getTokenInfo];
            //0管理员
            NSDictionary *parametersForManager = @{@"operatorName":userInfo[@"username"],
               @"accessToken":tokenInfo[@"accessToken"],
               @"approvalPerson":userInfo[@"username"],
               @"applicationStatus":@"reject"
               };
            //1工程师
            NSDictionary *parametersForWorker = @{@"operatorName":userInfo[@"username"],
                  @"accessToken":tokenInfo[@"accessToken"],
                  @"applicantName":userInfo[@"username"],
                  @"applicationStatus":@"reject"
                  };
            
            NSString *urlString = @"https://www.smartlock.top/v0/taskFetch";
            [post setDelegate:self];
            if([WorkDetailView getUserType] == 0)
            {
                [post postUrl:urlString withParams:parametersForManager];
            }else{
                [post postUrl:urlString withParams:parametersForWorker];
            }

            break;
        }
        //all
        case 3:
        {
            Post* post = [[Post alloc] init];
            NSDictionary* userInfo = [UserInfoView getUserInfo];
            NSDictionary* tokenInfo = [UserInfoView getTokenInfo];
            //0管理员
            NSDictionary *parametersForManager = @{@"operatorName":userInfo[@"username"],
               @"accessToken":tokenInfo[@"accessToken"],
               @"approvalPerson":userInfo[@"username"],
               };
            //1工程师
            NSDictionary *parametersForWorker = @{@"operatorName":userInfo[@"username"],
              @"accessToken":tokenInfo[@"accessToken"],
              @"applicantName":userInfo[@"username"],
              };
            
            NSString *urlString = @"https://www.smartlock.top/v0/taskFetch";
            [post setDelegate:self];
            if([WorkDetailView getUserType] == 0)
            {
                [post postUrl:urlString withParams:parametersForManager];
            }else{
                [post postUrl:urlString withParams:parametersForWorker];
            }

            break;
        }
            
    }
    
    
}


-(void)alertUI:(NSError *)error
{
    //初始化提示框；
    NSString* info = [[NSString alloc] initWithFormat:@"错误：%@",error];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
        message:info preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"返回登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)updateUI:(NSDictionary*)data
{
    NSLog(@"UpdateUI %@",data);
    NSArray* success = data[@"success"];
    NSLog(@"拉取的工单信息%@",data);
    if(success!=nil)
    {
        self.datalist = success;
        NSLog(@"工单长度： %d",success.count);
        [workTable reloadData];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.datalist count];
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
    NSDictionary* curData = [self.datalist objectAtIndex:row];
    cell.textLabel.text = [curData objectForKey:@"applicantName"];
    cell.detailTextLabel.text = [curData objectForKey:@"applyDescription"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d row is selected",indexPath.row);
    WorkDetailView *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"workdetails"];
    vc.workData = [self.datalist objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"工单详情";
}



@end
