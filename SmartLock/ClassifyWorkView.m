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
@synthesize typelist;
@synthesize workTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSArray *type = [[NSArray alloc] initWithObjects:@"工单申请",
                     @"已批准工单",
                     @"待批准工单",
                     @"驳回的工单",
                     @"所有工单",nil];
    NSArray *mdata = [[NSArray alloc] initWithObjects:
                      @"申请",
                      @"查看",
                      @"查看",
                      @"查看",
                      @"查看",
                      nil];
    
    
    self.datalist = mdata;
    self.typelist = type;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"%d row is selected",indexPath.row);
}


@end
