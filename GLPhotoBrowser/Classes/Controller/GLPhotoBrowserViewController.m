//
//  GLPhotoBrowserViewController.m
//  Pods
//
//  Created by gaoli on 16/5/4.
//
//

#import "GLPhotoBrowserViewController.h"
#import "GLPhotoView.h"
#import "GLPhotoScrollView.h"
#import "GLPhotoBrowserViewModel.h"
#import "FBKVOController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

static CGFloat const kPhotoSpacingWidth = 20.0f;

@interface GLPhotoBrowserViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray    *photoViews;
@property (nonatomic, strong) GLPhotoScrollView *scrollView;
@property (nonatomic, strong) FBKVOController   *KVOController;

@end

@implementation GLPhotoBrowserViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.modalTransitionStyle                 = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle               = UIModalPresentationOverCurrentContext;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.KVOController observe:self.viewModel
                        keyPath:@"index"
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          block:^(GLPhotoBrowserViewController *photoBrowser, GLPhotoBrowserViewModel *viewModel, NSDictionary *change) {
                              if (viewModel.count == 0) {
                                  return;
                              }
                              
                              [photoBrowser switchPhoto:viewModel.index];
                              
                              CGPoint point = {(SCREEN_W + kPhotoSpacingWidth) * viewModel.index, 0.0f};
                              
                              photoBrowser.scrollView.contentOffset = point;
                          }];
    
    [self.KVOController observe:self.viewModel
                        keyPath:@"count"
                        options:NSKeyValueObservingOptionInitial
                          block:^(GLPhotoBrowserViewController *photoBrowser, GLPhotoBrowserViewModel *viewModel, NSDictionary *change) {
                              if (viewModel.count == 0) {
                                  return;
                              }
                              
                              CGSize size = {(SCREEN_W + kPhotoSpacingWidth) * viewModel.count, SCREEN_H};
                              
                              photoBrowser.scrollView.contentSize = size;
                          }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showPhotoBrowser];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.scrollView.contentOffset.x / (SCREEN_W + kPhotoSpacingWidth);
    
    if (index < 0 || index >= self.viewModel.count) {
        return;
    }
    
    if (index != self.viewModel.index) {
        
        // 重置缩放比例
        [self resetZoomScale:self.viewModel.index];
        
        // 设置当前索引
        self.viewModel.index = index;
    }
}

#pragma mark - private methods

- (UIImageView *)thumbnailAtIndex:(NSInteger)index {
    GLPhotoDO *photoDO = [self.viewModel.photoDOs objectAtIndex:index];
    
    return photoDO.thumbnail;
}

- (CGRect)thumbnailRectAtIndex:(NSInteger)index {
    GLPhotoDO *photoDO = [self.viewModel.photoDOs objectAtIndex:index];
    
    return [photoDO.thumbnail convertRect:photoDO.thumbnail.bounds toView:nil];
}

- (void)loadPhoto:(NSInteger)index {
    if (index < 0 || index >= self.viewModel.count) {
        return;
    }
    
    id photoView = [self.photoViews objectAtIndex:index];
    
    if (![photoView isKindOfClass:[GLPhotoView class]]) {
        GLPhotoView *photoView = [[GLPhotoView alloc] init];
        
        CGRect frame = {{SCREEN_W * index + kPhotoSpacingWidth * (index + 1), 0.0f}, {SCREEN_W, SCREEN_H}};
        
        [photoView setFrame:frame];
        [photoView bindData:self.viewModel.photoDOs[index]];
        
        __weak __typeof(self) weakSelf = self;
        
        photoView.singleTapBlock = ^(UITapGestureRecognizer *sender) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf hidePhotoBrowser];
        };
        
        [self.scrollView addSubview:photoView];
        [self.photoViews replaceObjectAtIndex:index withObject:photoView];
    }
}

- (void)unloadPhoto:(NSInteger)index {
    if (index < 0 || index >= self.viewModel.count) {
        return;
    }
    
    id photoView = [self.photoViews objectAtIndex:index];
    
    if ([photoView isKindOfClass:[GLPhotoView class]]) {
        [photoView removeFromSuperview];
        [self.photoViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)switchPhoto:(NSInteger)index {
    [self loadPhoto  :index];
    [self loadPhoto  :index + 1];
    [self loadPhoto  :index - 1];
    [self unloadPhoto:index + 2];
    [self unloadPhoto:index - 2];
}

- (void)resetZoomScale:(NSInteger)index {
    if (index < 0 || index >= self.viewModel.count) {
        return;
    }
    
    id photoView = [self.photoViews objectAtIndex:index];
    
    if ([photoView isKindOfClass:[GLPhotoView class]]) {
        [photoView setZoomScale:[photoView minimumZoomScale] animated:YES];
    }
}

- (void)showPhotoBrowser {
    UIImageView *thumbnail     = [self thumbnailAtIndex    :self.viewModel.index];
    CGRect       thumbnailRect = [self thumbnailRectAtIndex:self.viewModel.index];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.frame         = thumbnailRect;
    imageView.image         = thumbnail.image;
    imageView.contentMode   = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         CGFloat imageW     = imageView.image.size.width;
                         CGFloat imageH     = imageView.image.size.height;
                         CGFloat imageViewW = SCREEN_W;
                         CGFloat imageViewH = (imageH / imageW) * SCREEN_W;
                         
                         if (imageViewH > SCREEN_H) {
                             imageView.frame = CGRectMake(0.0f, 0.0f, imageViewW, imageViewH);
                         } else {
                             imageView.frame = CGRectMake(0.0f, (SCREEN_H - imageViewH) / 2, imageViewW, imageViewH);
                         }
                     } completion:^(BOOL finished) {
                         self.scrollView.hidden = NO;
                         
                         [imageView removeFromSuperview];
                     }];
}

- (void)hidePhotoBrowser {
    GLPhotoView *photoView = [self.photoViews objectAtIndex:self.viewModel.index];
    
    if (photoView.imageView.image) {
        [self resetZoomScale:self.viewModel.index];
        
        self.scrollView.hidden = YES;
        
        UIImage     *image     = photoView.imageView.image;
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.image         = image;
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        CGFloat imageW     = image.size.width;
        CGFloat imageH     = image.size.height;
        CGFloat imageViewW = SCREEN_W;
        CGFloat imageViewH = (imageH / imageW) * SCREEN_W;
        
        if (imageViewH > SCREEN_H) {
            imageView.frame = CGRectMake(0.0f, 0.0f, imageViewW, imageViewH);
        } else {
            imageView.frame = CGRectMake(0.0f, (SCREEN_H - imageViewH) / 2, imageViewW, imageViewH);
        }
        
        [self.view addSubview:imageView];
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             imageView.frame = [self thumbnailRectAtIndex:self.viewModel.index];
                         } completion:^(BOOL finished) {
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getters and setters

- (NSMutableArray *)photoViews {
    if (_photoViews == nil) {
        _photoViews = [NSMutableArray array];
        
        for (int i = 0; i < self.viewModel.count; i++) {
            [_photoViews addObject:[NSNull null]];
        }
    }
    
    return _photoViews;
}

- (GLPhotoScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[GLPhotoScrollView alloc] init];
        
        CGRect frame = {{-kPhotoSpacingWidth, 0.0f}, {SCREEN_W + kPhotoSpacingWidth, SCREEN_H}};
        
        _scrollView.hidden                         = YES;
        _scrollView.frame                          = frame;
        _scrollView.delegate                       = self;
        _scrollView.pagingEnabled                  = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
    }
    
    return _scrollView;
}

- (FBKVOController *)KVOController {
    if (_KVOController == nil) {
        _KVOController = [FBKVOController controllerWithObserver:self];
    }
    
    return _KVOController;
}

@end
