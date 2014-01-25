//
// Created by liq on 12/12/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView(ZoomLevel)

- (NSUInteger) zoomLevel;

- (void) setCenterCoordinate:(CLLocationCoordinate2D) centerCoordinate
                   zoomLevel:(NSUInteger) zoomLevel
                    animated:(BOOL) animated;

@end