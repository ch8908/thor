//
// Created by Huang ChienShuo on 8/22/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BadOrder : NSObject
@property (nonatomic, readonly) NSString* orderName;
@property (nonatomic, readonly) NSString* imageFileName;
@property (nonatomic, readonly) NSString* placeId;
@property (nonatomic, readonly) NSString* placeName;
@property (nonatomic, readonly) NSInteger* score;
@property (nonatomic, readonly) NSArray* comments;
@property (nonatomic, readonly) long long uploadDate;

@end