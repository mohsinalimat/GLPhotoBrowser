//
//  GLPhotoView.m
//  Pods
//
//  Created by gaoli on 16/5/5.
//
//

#import "GLPhotoView.h"
#import "GLPhotoDO.h"
#import "GLCycleView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface GLPhotoView () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat                 zoomScale;
@property (nonatomic, strong) GLCycleView            *cycleView;
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
        [self addSubview:self.cycleView];
    }
    
    return self;
}

- (void)bindData:(GLPhotoDO *)data {
    __weak __typeof(self) weakSelf = self;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.url]
                      placeholderImage:data.thumbnail.image
                               options:0
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  __strong __typeof(weakSelf) strongSelf = weakSelf;
                                  
                                  CGFloat progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
                                  
                                  strongSelf.cycleView.hidden   = NO;
                                  strongSelf.cycleView.progress = progress;
                                  
                                  if (progress == 1.0f) {
                                      strongSelf.cycleView.hidden = YES;
                                  }
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 __strong __typeof(weakSelf) strongSelf = weakSelf;
                                 
                                 weakSelf.imageView.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
                                 
                                 // 设置缩放比例
                                 [strongSelf setMaxMinZoomScale];
                                 
                                 // 缩至最小比例
                                 [strongSelf setZoomScale:strongSelf.minimumZoomScale animated:NO];
                                 
                                 // 添加手势响应
                                 [strongSelf addGestureRecognizer:strongSelf.singleTapGestureRecognizer];
                                 [strongSelf addGestureRecognizer:strongSelf.doubleTapGestureRecognizer];
                             }];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    
    if ([imageCache diskImageExistsWithKey:data.url] == NO) {
        CGFloat imageW     = self.imageView.image.size.width;
        CGFloat imageH     = self.imageView.image.size.height;
        CGFloat imageViewW = SCREEN_W;
        CGFloat imageViewH = (imageH / imageW) * SCREEN_W;
        
        if (imageH > imageW) {
            self.imageView.frame = CGRectMake(0.0f, 0.0f, imageViewW, imageViewH);
        } else {
            self.imageView.frame = CGRectMake(0.0f, (SCREEN_H - imageViewH) / 2, imageViewW, imageViewH);
        }
    }
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

- (GLCycleView *)cycleView {
    if (_cycleView == nil) {
        _cycleView = [[GLCycleView alloc] init];
        
        _cycleView.frame  = CGRectMake((SCREEN_W - 20.0f) / 2,
                                       (SCREEN_H - 20.0f) / 2,
                                       20.0f,
                                       20.0f);
        _cycleView.hidden = YES;
    }
    
    return _cycleView;
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
