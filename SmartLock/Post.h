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
@required
-(void)updateUI:(NSDictionary*)data;
-(void)alertUI:(NSError*)error;

@optional
@end


@interface Post : NSObject
{
    id delegate;
    NSDictionary* data;
    NSError *error;
}

@property(strong, nonatomic) NSDictionary *data;
@property(strong, nonatomic) NSError *error;



-(void)setDelegate:(id)newDelegate;
-(void)postUrl:(NSString*)urlString  withParams:(NSDictionary*)parameters;


@end
