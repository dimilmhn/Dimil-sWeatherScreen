//
//  CCImageCache.m
//  PodcastPlayer
//
//  Created by Developer on 4/28/15.
//  Copyright (c) 2015 armia. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache
#pragma mark - Methods

static ImageCache* sharedImageCache = nil;

+(ImageCache *)sharedImageCache
{
    @synchronized([ImageCache class])
    {
        if (!sharedImageCache)
            sharedImageCache= [[self alloc] init];
        
        return sharedImageCache;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([ImageCache class])
    {
        NSAssert(sharedImageCache == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedImageCache = [super alloc];
        
        return sharedImageCache;
    }
    
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _imgCache = [[NSCache alloc] init];
    }
    
    return self;
}

- (void) addImage:(NSString *)imageGroup URL:(NSString *)imageURL image: (UIImage *)image
{
    if (imageURL && image) {
        NSMutableDictionary *images = [self.imgCache objectForKey:imageGroup];
        if (!images) {
            images = [[NSMutableDictionary alloc] init];
            [self.imgCache setObject:images forKey:imageGroup];
        }
        [images setValue:image forKey:imageURL];
    }
}

- (UIImage *) getImage:(NSString *)imageGroup URL:(NSString *)imageURL
{
    NSMutableDictionary *images = [self.imgCache objectForKey:imageGroup];
    if (images && images.count > 0) {
        return[images valueForKey:imageURL];
    }
    return nil;
}

- (BOOL) doesExist:(NSString *)imageGroup URL:(NSString *)imageURL
{
    NSMutableDictionary *images = [self.imgCache objectForKey:imageGroup];
    if (images && images.count > 0) {
        if ([images valueForKey:imageURL] != nil)
        {
            return true;
        }
    }
    return false;
}
- (void) clearImages:(NSString *)imageGroup
{
    NSMutableDictionary *images = [self.imgCache objectForKey:imageGroup];
    images = nil;
}
@end
