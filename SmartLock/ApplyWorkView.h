//
//  ApplyWorkView.h
//  SmartLock
//
//  Created by csis on 16/4/10.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyWorkView : UIViewController
{
    UITableView *applyTableView;
    NSArray *datalist;
    NSArray *typelist;
}

@property (strong, nonatomic) NSArray *datalist;
@property (strong, nonatomic) NSArray *typelist;
@property(strong, nonatomic) IBOutlet UITableView *applyTableView;
@end
