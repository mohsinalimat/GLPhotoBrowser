//
//  GLPhotoBrowserViewModel.m
//  Pods
//
//  Created by gaoli on 16/5/6.
//
//

#import "GLPhotoBrowserViewModel.h"

@implementation GLPhotoBrowserViewModel

- (id)initWithData:(NSMutableArray *)photoDOs index:(NSInteger)index {
    self = [super init];
    
    if (self) {
        self.index    = index;
        self.count    = photoDOs.count;
        self.photoDOs = photoDOs;
    }
    
    return self;
}

- (UIImageView *)thumbnailAtIndex:(NSInteger)index {
    GLPhotoDO *photoDO = [self.photoDOs objectAtIndex:index];
    
    return photoDO.thumbnail;
}

@end
