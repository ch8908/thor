//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 oSolve. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSString(Util)
+ (BOOL) isEmpty:(NSString *) string;

+ (BOOL) isEmptyAfterTrim:(NSString *) string;

- (NSString *) stringByTrim;
@end