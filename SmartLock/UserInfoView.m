//
//  UserInfoView.m
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "UserInfoView.h"

@interface UserInfoView ()

@end

@implementation UserInfoView
@synthesize personalTableView = _personalTableView;
@synthesize datalist = _datalist;
@synthesize typelist = _typelist;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSArray *type = [[NSArray alloc] initWithObjects:@"用户名", @"真实姓名",
                     @"手机号", @"用户类型", @"公司",@"公司组",
                    @"所属地级区域",@"所属县级区域",nil];

    NSArray *data = [[NSArray alloc] initWithObjects:@"用户名", @"真实姓名",
                     @"手机号", @"用户类型", @"公司",@"公司组",
                     @"所属地级区域",@"所属县级区域",nil];
    
    self.datalist = data;
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
    //    UIImage *image = [UIImage imageNamed:@"qq"];
    //    cell.imageView.image = image;
    //    UIImage *highLighedImage = [UIImage imageNamed:@"youdao"];
    //    cell.imageView.highlightedImage = highLighedImage;
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
