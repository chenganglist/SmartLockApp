//
//  WorkDetailView.h
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "UserInfoView.h"

@interface WorkDetailView : UIViewController<PostDelegate>
{
    UIButton *approveButton;
    UIButton *rejectButton;
    UITableView *workTable;
    NSDictionary *workData;
    NSMutableArray *datalist;
    NSMutableArray *typelist;
    NSMutableArray *keylist;
    UITextField *operateDescription;

    int classifyType; //0-approved  1-wait  2-reject  3-all
}

@property(nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property(nonatomic,retain) IBOutlet UIButton *approveButton;
@property(nonatomic,retain) IBOutlet UIButton *rejectButton;
@property(strong, nonatomic) IBOutlet UITextField *operateDescription;
@property (strong, nonatomic) NSDictionary *workData;
@property (nonatomic, readwrite) int classifyType;
@property(strong, nonatomic)  IBOutlet UITableView *workTable;
@property (strong, nonatomic) NSMutableArray *datalist;
@property (strong, nonatomic) NSMutableArray *typelist;
@property (strong, nonatomic) NSMutableArray *keylist;

+(void)setUserType:(int)type;
+(int)getUserType;

-(IBAction)approveButtonPressed:(id)sender;
-(IBAction)rejectButtonPressed:(id)sender;

@end
