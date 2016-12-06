//
//  GLPhotoView.h
//  Pods
//
//  Created by gaoli on 16/5/5.
//
//

#import <UIKit/UIKit.h>

@class GLPhotoDO;

@interface GLPhotoView : UIScrollView

@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *sender);

- (void)bindData:(GLPhotoDO *)data;

@end
