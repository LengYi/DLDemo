//
//  GaodeMapFactory.m
//  IOP
//
//  Created by ice on 17/3/28.
//  Copyright © 2017年 ice. All rights reserved.
//

#import "GaodeMapFactory.h"
#import "ImapView.h"
#import "GaodeMapView.h"

@implementation GaodeMapFactory

- (id<ImapView>)getMapViewWithFrame:(CGRect)frame{
    GaodeMapView *mapView = [[GaodeMapView alloc] initWithFrame:frame];
    //mapView.backgroundColor = [UIColor greenColor];
    return mapView;
}

@end
