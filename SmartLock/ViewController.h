//
//  ViewController.h
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "Post.h"
#import "WorkDetailView.h"

@interface ViewController : UIViewController<PostDelegate>
{
    UIButton *loginButton;
    UITextField *pwdTextField;
    UITextField *uidTextField;

}


@property(nonatomic,retain) IBOutlet UIButton *loginButton;
@property(strong, nonatomic) IBOutlet UITextField *uidTextField;
@property(strong, nonatomic) IBOutlet UITextField *pwdTextField;


-(IBAction)loginButtonPressed:(id)sender;


@end

