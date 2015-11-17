//
//  WeatherCollectionViewCell.h
//  Dimil'sWeatherScreen
//
//  Created by Developer on 11/16/15.
//  Copyright (c) 2015 DTM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "WeatherDataBase.h"

@interface WeatherCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) IBOutlet UILabel *weatherDay;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) IBOutlet UILabel *weatherTemp;
@property (nonatomic, strong) ImageDownloader *imageDownloader;
@property (strong, nonatomic)NSIndexPath *currentIndex;
- (void)downloadWeatherLogo;
@end
