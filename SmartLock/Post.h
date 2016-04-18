//
//  Post.h
//  SmartLock
//
//  Created by csis on 16/4/18.
//  Copyright © 2016年 csis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@protocol PostDelegate
-(void)updateUI:(NSDictionary*)data;
@end


@interface Post : NSObject
{
    id delegate;
    NSDictionary* data;
}


-(void)setDelegate:(id)newDelegate;
-(void)PostAPI;

@end
