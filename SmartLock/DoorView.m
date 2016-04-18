//
//  DoorView.m
//  SmartLock
//
//  Created by csis on 16/4/15.
//  Copyright © 2016年 csis. All rights reserved.
//

#import "DoorView.h"

@interface DoorView (){

}

@end

@implementation DoorView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    NSLog(@"准备打开设备");
    
//启动一个定时任务--扫描一定时间，停止扫描
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerTask) userInfo:nil repeats:NO];

}

-(void)timerTask{
    //停止扫描

}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    //停止之前的连接
}


-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}




#pragma mark -UIViewController 方法



#pragma mark -table委托 table delegate





@end
