//
//  CB_ImageDownloader.m
//  chitbox
//
//  Created by Developer on 8/21/15.
//  Copyright (c) 2015 chithub. All rights reserved.
//

#import "ImageDownloader.h"
#import "ImageCache.h"
@implementation ImageDownloader
- (id)initwithImageGroup:(NSString *)imageGroup imageURL:(NSString *)imageURL imageUpadateBlock:(void (^) (UIImage *))imageLoader
{
    if ([[ImageCache sharedImageCache]  doesExist:imageGroup URL:imageURL])
    {
        UIImage *downloadedImage = [[ImageCache sharedImageCache] getImage:imageGroup URL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageLoader(downloadedImage);
        });
    }
    else
    {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.requestCachePolicy=NSURLRequestReturnCacheDataElseLoad;
        sessionConfig.URLCache = [NSURLCache sharedURLCache];
        NSURLSession  *session = [ NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
        
        _imageDowloadTask =
        [session downloadTaskWithURL:[NSURL URLWithString:imageURL]
                   completionHandler:^(NSURL *location,
                                       NSURLResponse *response,
                                       NSError *error) {
                       UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                       [[ImageCache sharedImageCache] addImage:imageGroup URL:imageURL image:downloadedImage];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           imageLoader(downloadedImage);
                       });
                   }];
        [_imageDowloadTask resume];

    }
    return self;
}
@end
