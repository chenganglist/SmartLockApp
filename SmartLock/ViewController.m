//
//  ViewController.m
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize uidTextField = _uidTextField;
@synthesize pwdTextField = _pwdTextField;
@synthesize loginButton = _loginButton;
static NSDictionary * successInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSDictionary*)getSuccessInfo{
    return successInfo;
}



-(IBAction)uidDidEndOnExit:(id)sender{
    [pwdTextField  becomeFirstResponder];
}


-(void)loginButtonPressed:(id)sender{


    [self performSegueWithIdentifier:@"approve" sender:sender];

}


@end

