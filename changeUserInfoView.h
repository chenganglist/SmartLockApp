//
//  changeUserInfoView.h
//  SmartLock
//
//  Created by csis on 16/4/25.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "UserInfoView.h"

@interface changeUserInfoView : UIViewController<PostDelegate>

@property(nonatomic,retain) IBOutlet UIButton *saveUserChangeButton;
@property(strong, nonatomic) IBOutlet UITextField *userInfoFiled;
@property(strong, nonatomic) NSString* keyString;
@property(strong, nonatomic) NSString* dataString;
@property(strong, nonatomic) NSMutableArray *datalist;
@property(readwrite, nonatomic) NSInteger index;
-(IBAction)saveUserChangeButtonPressed:(id)sender;

@end
