//
//  NSString+Formatter.m
//  Dimil'sWeatherScreen
//
//  Created by Developer on 11/16/15.
//  Copyright (c) 2015 DTM. All rights reserved.
//

#import "NSString+Formatter.h"

@implementation NSString (Formatter)

- (NSString *)dateFormatterFromString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [df dateFromString:self];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%ld",(long)day ];
}

@end
