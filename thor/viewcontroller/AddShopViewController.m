//
// Created by Huang ChienShuo on 1/23/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AddShopViewController.h"
#import "Views.h"

@interface AddShopViewController()<MKMapViewDelegate>
@property MKMapView* mapView;
@end

@implementation AddShopViewController

- (id) initAddShopViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Views resize:self.mapView containerSize:CGSizeMake(self.view.bounds.size.width, 150)];
    [Views locate:self.mapView y:self.topBarOffset];

    [self.view addSubview:self.mapView];
}

@end