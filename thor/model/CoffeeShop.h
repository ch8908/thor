//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoffeeShop : NSObject
@property (nonatomic) NSNumber* id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) BOOL wifiFree;
@property (nonatomic) BOOL powerOutlet;

- (instancetype) initWithId:(NSNumber*) id name:(NSString*) name latitude:(double) latitude longitude:(double) longitude wifiFree:(BOOL) wifiFree powerOutlet:(BOOL) powerOutlet;

- (NSString*) infoString;

+ (instancetype) map:(NSDictionary*) raw;
@end