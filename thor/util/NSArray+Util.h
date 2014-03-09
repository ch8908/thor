//
//  NSArray+Util.h
//  nemo
//
//  Created by liq on 11/9/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(NSArray_Util)

/**
 * return an NSMutableArray
 */
- (NSArray*) map:(id (^)(id obj, NSUInteger index)) mapper;

- (NSArray*) partition:(NSUInteger) count;

- (NSArray*) filter:(BOOL (^)(id obj, NSUInteger index)) predicate;

- (void) forEach:(void (^)(id obj, NSUInteger index)) onElement;

- (id) findFirst:(BOOL (^)(id obj, NSUInteger index)) predicate;

- (NSArray*) orderByAnotherArray:(NSArray*) baseArray;


@end

@interface NSMutableArray(NSArray_Util)

- (void) nm_reverse;

- (void) nm_shuffle;

@end
