//
//  EntranceManageViewViewController.h
//  SmartLock
//
//  Created by csis on 16/4/25.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyManagementView.h"


@interface EntranceManageViewViewController : UIViewController

-(IBAction)keyManageButtonPressed:(id)sender;
-(IBAction)lockManageButtonPressed:(id)sender;
-(IBAction)rightsManageButtonPressed:(id)sender;
-(IBAction)openDoorButtonPressed:(id)sender;

@end
