//
//  MapAnnotation.h
//  YoGa
//
//  Created by Mac on 2018/9/3.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end
