//
// Created by Huang ChienShuo on 8/22/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface UserComment : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* comment;
@property (nonatomic) NSInteger score;

- (id) initUserCommentWithName:(NSString*) name comment:(NSString*) comment score:(NSInteger) score;
@end