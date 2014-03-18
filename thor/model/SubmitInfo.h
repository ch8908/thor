//
// Created by Huang ChienShuo on 1/25/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SubmitInfo : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *websiteUrl;
@property (nonatomic, assign) BOOL isWifiFree;
@property (nonatomic, assign) BOOL powerOutlets;
@property (nonatomic, strong) NSString *hours;
@property (nonatomic, strong) NSString *shopDescription;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *address;

- (instancetype) initWithName:(NSString *) name
                        phone:(NSString *) phone
                   websiteUrl:(NSString *) websiteUrl
                   isWifiFree:(BOOL) isWifiFree
                 powerOutlets:(BOOL) powerOutlets
                        hours:(NSString *) hours
              shopDescription:(NSString *) shopDescription
                     latitude:(double) latitude
               longitudeDelta:(double) longitudeDelta
                      address:(NSString *) address;

- (NSDictionary *) infoAsDictionaryWithToken:(NSString *) token;

@end