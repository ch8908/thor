//
// Created by Huang ChienShuo on 2/16/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BOOLPref : NSObject

+ (instancetype) prefWithKey:(NSString *) key;

+ (instancetype) prefWithKey:(NSString *) key defaultValue:(BOOL) defaultValue;

- (void) setBool:(BOOL) boolValue;

- (BOOL) getBool;
@end

@interface NSStringPref : NSObject

+ (instancetype) prefWithKey:(NSString *) key;

+ (instancetype) prefWithKey:(NSString *) key defaultString:(NSString *) defaultString;

- (void) setString:(NSString *) defaultString;

- (NSString *) getString;

- (void) removeString;

@end

@interface NSNumberPref : NSObject

+ (instancetype) prefWithKey:(NSString *) key;

+ (instancetype) prefWithKey:(NSString *) key defaultNumber:(NSNumber *) defaultValue;

- (void) setNumber:(NSNumber *) defaultNumber;

- (NSNumber *) getNumber;

- (void) removeNumber;

@end

@interface AbstractPref : NSObject
@end