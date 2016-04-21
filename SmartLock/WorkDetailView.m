//
//  WorkDetailView.m
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "WorkDetailView.h"

@interface WorkDetailView ()

@end

@implementation WorkDetailView
@synthesize  workTable,workData,datalist,typelist
,keylist,classifyType,operateDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
    
    NSMutableArray *type = [[NSMutableArray alloc] initWithObjects:@"申请人", @"工单ID",@"申请人公司", @"申请人电话", @"作业类型",@"作业描述",
        @"电子钥匙ID",@"作业开始时间",@"作业结束时间",@"开门次数",nil];

    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:workData[@"applicantName"],
                        workData[@"taskID"],
                        workData[@"applicantCompany"],
                        workData[@"applicantPhone"],
                        workData[@"applicationType"],
                        workData[@"applyDescription"],
                        workData[@"applicantKeyID"],
                        workData[@"taskStartTime"],
                        workData[@"taskEndTime"],
                        workData[@"taskTimes"],nil];
    
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
