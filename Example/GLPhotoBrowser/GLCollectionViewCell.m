//
//  GLCollectionViewCell.m
//  GLPhotoBrowser
//
//  Created by 高力 on 16/5/6.
//  Copyright © 2016年 高力. All rights reserved.
//

#import "GLCollectionViewCell.h"

@implementation GLCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.thumbnail];
    }
    
    return self;
}

#pragma mark - getters and setters

- (UIImageView *)thumbnail {
    if (_thumbnail == nil) {
        _thumbnail = [[UIImageView alloc] init];
        
        CGRect frame = {{0.0f, 0.0f}, self.frame.size};
        
        _thumbnail.frame         = frame;
        _thumbnail.contentMode   = UIViewContentModeScaleAspectFill;
        _thumbnail.clipsToBounds = YES;
    }
    
    return _thumbnail;
}

@end
