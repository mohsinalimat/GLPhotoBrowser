//
//  GLPhotoView.m
//  Pods
//
//  Created by gaoli on 16/5/5.
//
//

#import "GLPhotoView.h"
#import "GLPhotoDO.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface GLPhotoView () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat                 zoomScale;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation GLPhotoView

- (id)init {
    self = [super init];
    
    if (self) {
        self.delegate                       = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        
        [self addSubview:self.imageView];
    }
    
    return self;
}

- (void)bindData:(GLPhotoDO *)data {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.url]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 // 设置图片布局
                                 [self setImageFrame];
                                 
                                 // 设置缩放比例
                                 [self setMaxMinZoomScale];
                                 
                                 // 缩至最小比例
                                 [self setZoomScale:self.minimumZoomScale animated:NO];
                                 
                                 // 添加手势响应
                                 [self addGestureRecognizer:self.singleTapGestureRecognizer];
                                 [self addGestureRecognizer:self.doubleTapGestureRecognizer];
                             }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setImageCenterPoint];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.zoomScale = scale;
}

#pragma mark - event response

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (self.singleTapBlock) {
        self.singleTapBlock(sender);
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    CGFloat scale;
    CGPoint center = [sender locationInView:self.imageView];
    
    if (self.zoomScale == 0.0f || self.zoomScale == self.minimumZoomScale) {
        scale = self.maximumZoomScale;
    } else {
        scale = self.minimumZoomScale;
    }
    
    [self zoomToRect:[self zoomRectForScale:scale withCenter:center] animated:YES];
}

#pragma mark - private methods

- (void)setImageFrame {
    CGSize size = self.imageView.image.size;
    
    self.imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
}

- (void)setMaxMinZoomScale {
    CGFloat minScale = 1.0f;
    CGFloat maxScale = 1.0f;
    CGSize  size     = self.imageView.frame.size;
    
    if (size.width > 0 && size.height > 0) {
        CGFloat xScale = SCREEN_W / size.width;
        CGFloat yScale = SCREEN_H / size.height;
        
        if (xScale * size.width - SCREEN_W > FLT_EPSILON) {
            xScale = floorf(xScale * 1000) / 1000;
        }
        
        minScale = MIN(xScale, yScale);
        
        if (size.width >= size.height) {
            maxScale = yScale;
        } else {
            maxScale = minScale * 2;
        }
    }
    
    self.minimumZoomScale = minScale;
    self.maximumZoomScale = maxScale;
}

- (void)setImageCenterPoint {
    CGFloat x    = 0.0f;
    CGFloat y    = 0.0f;
    CGSize  size = self.imageView.frame.size;
    
    if (size.width  < SCREEN_W) {
        x = (SCREEN_W - size.width)  / 2;
    }
    
    if (size.height < SCREEN_H) {
        y = (SCREEN_H - size.height) / 2;
    }
    
    self.imageView.center = CGPointMake(x + size.width / 2, y + size.height / 2);
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2);
    
    return zoomRect;
}

#pragma mark - getters and setters

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _imageView;
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer {
    if (_singleTapGestureRecognizer == nil) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        
        [_singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    }
    
    return _singleTapGestureRecognizer;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (_doubleTapGestureRecognizer == nil) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    
    return _doubleTapGestureRecognizer;
}

@end
