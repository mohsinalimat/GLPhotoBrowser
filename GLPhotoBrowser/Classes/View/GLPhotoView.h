//
//  GLPhotoView.h
//  Pods
//
//  Created by 高力 on 16/5/5.
//
//

#import <UIKit/UIKit.h>

@class GLPhotoDO;

@interface GLPhotoView : UIScrollView

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;

- (void)bindData:(GLPhotoDO *)data;

@end
