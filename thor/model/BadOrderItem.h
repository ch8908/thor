//
// Created by Huang ChienShuo on 9/5/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BadOrderItem : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* comment;
@property (nonatomic, copy) NSString* imageFileName;
@property (nonatomic, copy) NSString* poster;
@property (nonatomic, copy) NSString* orderId;
@property (nonatomic) NSInteger score;

- (id) initBadOrderItemWithName:(NSString*) name orderId:(NSString*) orderId comment:(NSString*) comment imageFileName:(NSString*) imageFileName poster:(NSString*) poster score:(NSInteger) score;
@end