//
//  ApplyWorkView.h
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "UserInfoView.h"

@interface ApplyWorkView : UIViewController<PostDelegate>
{
    UIButton *resetButton;
    UIButton *commitButton;
    UITextField *stationAddress;
    UITextField *workType;
    UIButton *startTimeButton;
    UIButton *endTimeButton;
    NSDate* startDate;
    NSDate* endDate;
    UITextField *electronicKey;
    UITextField *workDescription;
    UIScrollView* scrollView;
}

@property(nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property(nonatomic,retain) IBOutlet UIButton *resetButton;
@property(nonatomic,retain) IBOutlet UIButton *commitButton;
@property(strong, nonatomic) IBOutlet UITextField *stationAddress;
@property(strong, nonatomic) IBOutlet UITextField *workType;
@property(strong, nonatomic) IBOutlet UIButton *startTimeButton;
@property(strong, nonatomic) IBOutlet UIButton *endTimeButton;
@property(strong, nonatomic) IBOutlet UITextField *electronicKey;
@property(strong, nonatomic) IBOutlet UITextField *workDescription;

-(IBAction)resetButtonPressed:(id)sender;
-(IBAction)commitButtonPressed:(id)sender;
-(IBAction)startTimeLablePressed:(id)sender;
-(IBAction)endTimeLablePressed:(id)sender;

@end
