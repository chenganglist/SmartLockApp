//
//  UserInfoView.h
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@interface UserInfoView : UIViewController<PostDelegate>
{
    UITableView *personalTableView;
    NSMutableArray *datalist;
    NSMutableArray *typelist;
    NSMutableArray *keylist;
    NSIndexPath *curIndexPath;
    NSString* changedValue;
}

@property (strong, nonatomic) NSMutableArray *keylist;
@property (strong, nonatomic) NSString* changedValue;
@property (strong, nonatomic) NSIndexPath *curIndexPath;
@property (strong, nonatomic) NSMutableArray *datalist;
@property (strong, nonatomic) NSMutableArray *typelist;
@property(strong, nonatomic) IBOutlet UITableView *personalTableView;

+(void)setUserInfo:(NSDictionary*)Info;
+(void)setRegionInfo:(NSDictionary*)Info;
+(void)setPermissionInfo:(NSDictionary*)Info;
+(void)setTokenInfo:(NSDictionary*)Info;

@end
