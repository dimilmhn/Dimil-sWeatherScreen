//
//  CB_ImageDownloader.h
//  chitbox
//
//  Created by Developer on 8/21/15.
//  Copyright (c) 2015 chithub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"

@interface ImageDownloader : NSObject
- (id)initwithImageGroup:(NSString *)imageGroup imageURL:(NSString *)imageURL imageUpadateBlock:(void (^) (UIImage *))imageLoader;
@property(nonatomic,strong) NSURLSessionDownloadTask *imageDowloadTask;

@end
