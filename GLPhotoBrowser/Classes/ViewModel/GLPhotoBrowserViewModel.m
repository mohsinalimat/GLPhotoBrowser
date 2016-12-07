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

@end
