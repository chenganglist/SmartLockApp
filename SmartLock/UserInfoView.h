//
//  UserInfoView.h
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDetailView.h"
#import "changeUserInfoView.h"


@interface UserInfoView : UITableViewController
{
    UITableView *personalTableView;
}


@property(strong, nonatomic) IBOutlet UITableView *personalTableView;

+(void)setUserInfo:(NSDictionary*)Info;
+(void)setRegionInfo:(NSDictionary*)Info;
+(void)setPermissionInfo:(NSDictionary*)Info;
+(void)setTokenInfo:(NSDictionary*)Info;
+(NSMutableDictionary*)getUserInfo;
+(NSMutableDictionary*)getRegionInfo;
+(NSMutableDictionary*)getPermissionInfo;
+(NSMutableDictionary*)getTokenInfo;
+(void)setDataList:(NSMutableArray*)Info;

@end
