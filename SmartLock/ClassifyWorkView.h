//
//  ClassifyWorkView.h
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "UserInfoView.h"

@interface ClassifyWorkView : UITableViewController<PostDelegate>
{
    UITableView *workTable;
    NSArray *datalist;
    int classifyType; //0-approved  1-wait  2-reject  3-all
}

@property (strong, nonatomic) NSArray *datalist;
@property (nonatomic, readwrite) int classifyType;
@property(strong, nonatomic)  IBOutlet UITableView *workTable;

@end
