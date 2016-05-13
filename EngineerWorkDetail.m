//
//  WorkDetailView.m
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "EngineerWorkDetail.h"


@interface EngineerWorkDetail ()

@end

@implementation EngineerWorkDetail
@synthesize  workTable,workData,datalist,typelist
,keylist,classifyType;



-(void)viewDidAppear:(BOOL)animated{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    NSMutableArray *type = [[NSMutableArray alloc] initWithObjects:@"申请人", @"工单ID",@"申请人公司", @"申请人电话", @"作业类型",@"作业描述",
                            @"基站地址",@"电子钥匙ID",@"作业开始时间",@"作业结束时间",@"开门次数",
                            @"工单状态",@"审批人",@"审批人电话",@"审批说明",nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:[workData[@"taskEndTime"] doubleValue] ];
    
    NSString *endDateString = [dateFormatter stringFromDate:endDate];

    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:[workData[@"taskStartTime"] doubleValue] ];
    
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:
                            (workData[@"applicantName"]==nil)?@"未定义":workData[@"applicantName"],
                            (workData[@"taskID"]==nil)?@"未定义":workData[@"taskID"],
                            (workData[@"applicantCompany"]==nil)?@"未定义":workData[@"applicantCompany"],
                            (workData[@"applicantPhone"]==nil)?@"未定义":workData[@"applicantPhone"],
                            (workData[@"applicationType"]==nil)?@"未定义":workData[@"applicationType"],
                            (workData[@"applyDescription"]==nil)?@"未定义":workData[@"applyDescription"],
                            (workData[@"stationAddress"]==nil)?@"未定义":workData[@"stationAddress"],
                            (workData[@"applicantKeyID"]==nil)?@"未定义":workData[@"applicantKeyID"],
                            (startDateString==nil)?@"未定义":startDateString,
                            (endDateString==nil)?@"未定义":endDateString,
                            (workData[@"taskTimes"]==nil)?@"未定义":workData[@"taskTimes"],
                            (workData[@"applicationStatus"]==nil)?@"未定义":workData[@"applicationStatus"],
                            (workData[@"approvalPerson"]==nil)?@"未定义":workData[@"approvalPerson"],
                            (workData[@"approvalPhone"]==nil)?@"未定义":workData[@"approvalPhone"],
                            (workData[@"reason"]==nil)?@"未定义":workData[@"reason"],nil];
    
    self.datalist = data;
    self.typelist = type;
    
    self.keylist = [[NSMutableArray alloc] initWithObjects:@"applicantName",
                    @"taskID",
                    @"applicantCompany", @"applicantPhone",
                    @"applicationType", @"applyDescription",
                    @"stationAddress",
                    @"applicantKeyID", @"taskStartTime",
                    @"taskEndTime",@"taskTimes",
                    @"applicationStatus",@"approvalPerson",
                    @"approvalPhone",@"reason",nil];
    
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",
                           [self.typelist objectAtIndex:row]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 [self.datalist objectAtIndex:row]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowString = [NSString stringWithFormat:@"%@",
                           [self.typelist objectAtIndex:[indexPath row]]];
    NSString *dataString = [NSString stringWithFormat:@"%@",
                            [self.datalist objectAtIndex:[indexPath row]]];
    
    NSString *keyString = [NSString stringWithFormat:@"%@",
                           [self.keylist objectAtIndex:[indexPath row]]];
    
    NSString* actionTitle = @"确定";
    
    if([keyString isEqualToString:@"stationAddress"])
    {
        actionTitle = @"导航去基站";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:rowString message:dataString preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([keyString isEqualToString:@"stationAddress"])
        {
            BaiduDituNaviView *vc = [[BaiduDituNaviView alloc]initWithNibName:@"BaiduDituNaviView" bundle:nil];
            vc._address = dataString;
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"地图导航";
        }
    }
                                ]];
    
    
    if([keyString isEqualToString:@"stationAddress"])
    {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     
                                 }];
        
        [alertController addAction:cancel];
    }
    
    //弹出提示框；
    [self presentViewController:alertController animated:true completion:nil];
    
}


@end
