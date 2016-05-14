//
//  WorkDetailView.h
//  SmartLock
//
//  Created by csis on 16/4/21.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoView.h"
#import "BaiduDituNaviView.h"


@interface EngineerWorkDetail : UIViewController
{
    UITableView *workTable;
    NSDictionary *workData;
    NSMutableArray *datalist;
    NSMutableArray *typelist;
    NSMutableArray *keylist;

    int classifyType; //0-approved  1-wait  2-reject  3-all
}

@property (strong, nonatomic) NSDictionary *workData;
@property (nonatomic, readwrite) int classifyType;
@property(strong, nonatomic)  IBOutlet UITableView *workTable;
@property (strong, nonatomic) NSMutableArray *datalist;
@property (strong, nonatomic) NSMutableArray *typelist;
@property (strong, nonatomic) NSMutableArray *keylist;

@end
