//
//  ManageWorkView.m
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "ManageWorkView.h"
#import "ViewController.h"

@interface ManageWorkView ()

@end


static NSDictionary * applyInfo;

@implementation ManageWorkView
@synthesize datalist = _datalist;
@synthesize typelist = _typelist;
@synthesize applyTableView = _applyTableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSArray *type = [[NSArray alloc] initWithObjects:@"工单申请",
                     @"已批准工单",
                     @"待批准工单",
                     @"驳回的工单",
                     @"所有工单",nil];
    NSArray *mdata = [[NSArray alloc] initWithObjects:
                      @"",
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.datalist = nil;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    switch(indexPath.row)
    {
        case 0:
        {
            NSLog(@" %ld",(long)indexPath.row);
            //页面跳转
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"applywork"];
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"任务申请";

            break;
        }
        case 1:
        {
            NSLog(@" %ld",(long)indexPath.row);
            //页面跳转
            UITableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"managework"];
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"已批准的工单";
            break;
        }
        case 2:
        {
            NSLog(@" %ld",(long)indexPath.row);
            //页面跳转
            UITableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"managework"];
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"待批准的工单";
            break;
        }
        case 3:
        {
            NSLog(@" %ld",(long)indexPath.row);
            //页面跳转
            UITableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"managework"];
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"驳回的工单";
            break;
        }
        case 4:
        {
            NSLog(@" %ld",(long)indexPath.row);
            //页面跳转
            UITableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"managework"];
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"所有工单";
            break;
        }
            
    }

}





@end
