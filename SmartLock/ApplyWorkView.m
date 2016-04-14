//
//  UserInfoView.m
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "ApplyWorkView.h"
#import "ViewController.h"

@interface ApplyWorkView ()

@end

@implementation ApplyWorkView
@synthesize applyTableView = _applyTableView;
@synthesize datalist = _datalist;
@synthesize typelist = _typelist;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *type = [[NSArray alloc] initWithObjects:@"基站名称",
                     @"基站地址",@"电子钥匙ID",@"任务内容",@"任务类型",@"任务开始时间",@"任务结束时间",nil];
    NSArray *mdata = [[NSArray alloc] initWithObjects:
                      @"金牛跃进村基站",
                      @"成都市金牛区金牛乡跃进村",
                      @"12:3e:5b:6e:7c",
                      @"维修电表",
                      @"普通",
                      @"2016-4-12",
                      @"2016-4-13",
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
