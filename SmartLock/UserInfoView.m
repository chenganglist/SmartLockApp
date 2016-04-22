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

@interface UserInfoView ()

@end

@implementation UserInfoView
@synthesize personalTableView,keylist;
@synthesize datalist,changedValue;
@synthesize typelist,curIndexPath;

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
    
    self.datalist = data;
    self.typelist = type;
    
    self.keylist = [[NSMutableArray alloc] initWithObjects:@"username",
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
    self.datalist = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.personalTableView.contentSize = CGSizeMake(0,1000);
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
    NSString* keyString = [self.keylist objectAtIndex:[indexPath row]];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:rowString message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.text = dataString;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if( [keyString isEqualToString:@"userType"] )
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                message:@"该项不可更改" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            return;
        }
        Post* post = [[Post alloc] init];
        NSDictionary *parameters =
            @{@"operatorName":userInfo[@"username"],
            @"accessToken":tokenInfo[@"accessToken"],
            @"originalName":userInfo[@"username"],
            keyString:alertController.textFields.firstObject.text
                  };
        NSString *urlString = @"https://www.smartlock.top/v0/updateUser";
        [post setDelegate:self];
        [post postUrl:urlString withParams:parameters];
        //Post修改用户信息
        self.curIndexPath = indexPath;
        self.changedValue = alertController.textFields.firstObject.text;
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alertController animated:true completion:nil];
    
}


//用户信息修改失败
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

//用户信息修改成功
-(void)updateUI:(NSDictionary*)data
{
    NSLog(@"UpdateUI %@",data);
    NSDictionary* success = data[@"success"];
    
    if(success!=nil)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
           message:@"信息修改成功" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            NSString* key = [self.keylist objectAtIndex:self.curIndexPath.row];
            [userInfo setObject:self.changedValue forKey:key];
            
            [self.datalist replaceObjectAtIndex:[self.curIndexPath row]
                    withObject:self.changedValue ];
            
            NSIndexPath *mindexPath=[NSIndexPath indexPathForRow:[self.curIndexPath row] inSection:0];
            [personalTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:mindexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

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


@end
