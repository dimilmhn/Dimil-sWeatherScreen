//
//  WeatherData.h
//  Dimil'sWeatherScreen
//
//  Created by Developer on 11/16/15.
//  Copyright (c) 2015 DTM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherData : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * temp;
@property (nonatomic, retain) NSData * icon;

@end
