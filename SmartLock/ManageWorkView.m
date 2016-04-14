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
    NSArray *type = [[NSArray alloc] initWithObjects:@"工单1", @"工单2",
                     @"工单3", @"工单4", @"工单5",@"工单6",
                     @"工单7",@"工单8",nil];
    NSString* userType = @"管理员";
    NSArray *mdata = [[NSArray alloc] initWithObjects:
                      @"成都蜀汉路朗格酒店",
                      @"金牛跃进村",
                      @"高新西区电子科大",userType,
                      @"温江绿道",
                      @"成都高新南区",
                      @"绵阳",
                      @"新疆",
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
    cell.detailTextLabel.text = [self.datalist objectAtIndex:row];;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowString = [self.typelist objectAtIndex:[indexPath row]];
    NSString *dataString = [self.datalist objectAtIndex:[indexPath row]];
    
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:rowString
                                                                   message:dataString
                                                            preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}





@end
