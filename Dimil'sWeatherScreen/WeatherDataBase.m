//
//  WeatherDataBase.m
//  Dimil'sWeatherScreen
//
//  Created by Developer on 11/16/15.
//  Copyright (c) 2015 DTM. All rights reserved.
//

#import "WeatherDataBase.h"
#import "NSString+Formatter.h"

@implementation WeatherDataBase
+ (WeatherDataBase *)sharedDatabase {
    static WeatherDataBase *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)savedataArray
{

    NSArray *combinedArray=[[_previousDataArray copy] arrayByAddingObjectsFromArray:[_weatherDataArray copy]];
    NSLog(@"combinedArray=%@",combinedArray);
    int i=0;
    for (NSDictionary *dic in combinedArray)
    {
        WeatherData *weatherDetails = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherData"
                                                                    inManagedObjectContext:[[AppDelegate delegate]managedObjectContext]];
        if(i<4)
        {
            weatherDetails.day       =dic[@"day"];
            weatherDetails.temp       =dic[@"temp"];
//            weatherDetails.icon       =nil;
        }
        else
        {
            weatherDetails.day       =[dic[@"date"] dateFormatterFromString];
            weatherDetails.temp       =dic[@"tempMaxC"];
//            weatherDetails.icon       =[dic[@"weatherIconUrl"]objectAtIndex:0][@"value"];
            
        }
        [self saveContent];
        i++;
  
    }
    NSLog(@"fethTheDetail  %@",[self fethTheDetail]);

}
// save data method
- (void)saveContent
{
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(saveContext)])
    {
        [delegate saveContext];
    }
}

- (NSArray *)fethTheDetail
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"WeatherData" inManagedObjectContext:[[AppDelegate delegate]managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [[[AppDelegate delegate]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
}
- (void)deleteItems
{
    for (int i=0; i<[self fethTheDetail].count; i++)
    {
            [[AppDelegate delegate] deleteContext:[[self fethTheDetail] objectAtIndex:i]];
        
    }
    NSError *error1 = nil;
    if ([[[AppDelegate delegate]managedObjectContext] save:&error1] == NO)
    {
        NSAssert(NO, @"Save should not fail\n%@", [error1 localizedDescription]);
        abort();
    }

}

@end
