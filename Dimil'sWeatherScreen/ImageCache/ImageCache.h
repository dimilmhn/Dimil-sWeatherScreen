//
//  CCImageCache.h
//  PodcastPlayer
//
//  Created by Developer on 4/28/15.
//  Copyright (c) 2015 armia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageCache : NSObject

    @property (nonatomic, retain) NSCache *imgCache;

#pragma mark - Methods

+ (ImageCache*)sharedImageCache;
- (void) addImage:(NSString *)imageGroup URL:(NSString *)imageURL image: (UIImage *)image;
- (UIImage *) getImage:(NSString *)imageGroup URL:(NSString *)imageURL;
- (BOOL) doesExist:(NSString *)imageGroup URL:(NSString *)imageURL;
- (void) clearImages:(NSString *)imageGroup;
@end



