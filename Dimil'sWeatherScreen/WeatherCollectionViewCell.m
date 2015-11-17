//
//  WeatherCollectionViewCell.m
//  Dimil'sWeatherScreen
//
//  Created by Developer on 11/16/15.
//  Copyright (c) 2015 DTM. All rights reserved.
//

#import "WeatherCollectionViewCell.h"
#import "WeatherData.h"
@implementation WeatherCollectionViewCell
- (void)downloadWeatherLogo
{
    self.imageDownloader=[[ImageDownloader alloc] initwithImageGroup:@"MenuIcons"
                                                               imageURL:_iconURL
                                                      imageUpadateBlock:^(UIImage *image)
                          {
                              self.weatherIcon.image=image;
                              [self saveImageObject:image];
                            
                          }];

}
- (void)saveImageObject:(UIImage *)image
{
    WeatherData *weatherData = [[[WeatherDataBase sharedDatabase]fethTheDetail]objectAtIndex:_currentIndex.row];
    NSData *imageData = UIImagePNGRepresentation(image);
    weatherData.icon=imageData;
    [[WeatherDataBase sharedDatabase] saveContent];
    
}
@end
