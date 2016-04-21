//
//  ClassifyWorkView.h
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyWorkView : UITableViewController
{
    UITableView *workTable;
    NSArray *datalist;
    NSArray *typelist;
}

@property (strong, nonatomic) NSArray *datalist;
@property (strong, nonatomic) NSArray *typelist;
@property(strong, nonatomic) IBOutlet UITableView *workTable;

@end
