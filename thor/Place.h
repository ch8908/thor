//
// Created by Huang ChienShuo on 8/21/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Place : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* id;
@property (nonatomic, readonly) NSString* address;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;


- (id) initWithName:(NSString*) name id:(NSString*) id1 address:(NSString*) address latitude:(double) latitude longitude:(double) longitude;
@end