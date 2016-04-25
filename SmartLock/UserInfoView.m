//
//  UserInfoView.m
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "UserInfoView.h"
static NSMutableDictionary* userInfo;
static NSMutableDictionary* regionInfo;
static NSMutableDictionary* permissionInfo;
static NSMutableDictionary* tokenInfo;
static NSMutableArray *datalist;
static NSMutableArray *typelist;
static NSMutableArray *keylist;
static NSIndexPath *curIndexPath;

@interface UserInfoView ()

@end

@implementation UserInfoView
@synthesize personalTableView;



+(void)setUserInfo:(NSDictionary*)Info
{
    userInfo = [NSMutableDictionary dictionaryWithDictionary:Info];
}
+(void)setRegionInfo:(NSDictionary*)Info
{
    regionInfo = [NSMutableDictionary dictionaryWithDictionary:Info];
}
+(void)setPermissionInfo:(NSDictionary*)Info
{
    permissionInfo = [NSMutableDictionary dictionaryWithDictionary:Info];
}
+(void)setTokenInfo:(NSDictionary*)Info
{
    tokenInfo = [NSMutableDictionary dictionaryWithDictionary:Info];
}

+(void)setDataList:(NSMutableArray*)Info{
    datalist = Info;
}

+(NSMutableDictionary*)getUserInfo
{
    return userInfo;
}

+(NSMutableDictionary*)getRegionInfo
{
    return regionInfo;
}

+(NSMutableDictionary*)getPermissionInfo
{
    return permissionInfo;
}

+(NSMutableDictionary*)getTokenInfo
{
    return tokenInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *type = [[NSMutableArray alloc] initWithObjects:@"用户名", @"真实姓名",
                     @"手机号", @"用户类型", @"公司",@"公司组",
                    @"所属地级区域",@"所属县级区域",nil];
    NSString* userType = @"管理员";
    [WorkDetailView setUserType:0]; //0管理员
    if( userInfo[@"userType"]==nil ||
        [(NSString*)userInfo[@"userType"] length] < 3 ||
       [[userInfo[@"userType"] substringFromIndex:2] isEqualToString:@"3"] )
    {
        userType = @"工程师";
        [WorkDetailView setUserType:1];//1工程师
    }
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:userInfo[@"username"],
                     userInfo[@"realname"],
                     userInfo[@"phone"], userType,
                     userInfo[@"company"], userInfo[@"companyGroup"],
                     regionInfo[@"managementCity"],
                     regionInfo[@"managementArea"],nil];
    
    datalist = data;
    typelist = type;
    
    keylist = [[NSMutableArray alloc] initWithObjects:@"username",
                    @"realname",
                    @"phone", @"userType",
                    @"company", @"companyGroup",
                    @"managementCity",
                    @"managementArea",nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    datalist = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.personalTableView.contentSize = CGSizeMake(0,600);
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [typelist count];
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
    cell.textLabel.font = [UIFont systemFontOfSize:24];
    cell.textLabel.text = [typelist objectAtIndex:row];
    cell.detailTextLabel.text = [datalist objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowString = [typelist objectAtIndex:[indexPath row]];
    NSString *dataString = [datalist objectAtIndex:[indexPath row]];
    NSString* keyString = [keylist objectAtIndex:[indexPath row]];
    
    
    changeUserInfoView *vc = [[changeUserInfoView alloc]initWithNibName:@"changeUserInfoView" bundle:nil];
    vc.dataString = dataString;
    vc.title = rowString;
    vc.keyString = keyString;
    vc.datalist = datalist;
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];

}

//刷新界面
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}


@end
