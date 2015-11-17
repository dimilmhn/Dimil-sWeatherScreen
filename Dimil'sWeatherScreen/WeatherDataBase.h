//
//  WeatherDataBase.h
//  Dimil'sWeatherScreen
//
//  Created by Developer on 11/16/15.
//  Copyright (c) 2015 DTM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"
#import "AppDelegate.h"
@interface WeatherDataBase : NSObject

@property (strong,nonatomic) NSMutableArray *weatherDataArray;
@property (strong,nonatomic) NSMutableArray *previousDataArray;

- (void)savedataArray;
- (void)deleteItems;

+ (WeatherDataBase *)sharedDatabase ;
- (NSArray *)fethTheDetail;
- (void)saveContent;

@end
