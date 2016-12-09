//
//  GLCycleView.m
//  Pods
//
//  Created by gaoli on 2016/12/9.
//
//

#import "GLCycleView.h"

static CGFloat const kRadius = 10.0f;

@interface GLCycleView ()

@property (nonatomic, strong) CAShapeLayer *blackLayer;
@property (nonatomic, strong) CAShapeLayer *whiteLayer;

@end

@implementation GLCycleView

- (id)init {
    self = [super init];
    
    if (self) {
        [self.layer addSublayer:self.blackLayer];
        [self.layer addSublayer:self.whiteLayer];
        
        self.whiteLayer.strokeEnd = 0.0f;
    }
    
    return self;
}

#pragma mark - getters and setters

- (CAShapeLayer *)blackLayer {
    if (_blackLayer == nil) {
        _blackLayer = [CAShapeLayer layer];
        
        CGPoint center     = CGPointMake(kRadius, kRadius);
        CGFloat radius     = kRadius;
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle   = -M_PI_2 + M_PI * 2;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:YES];
        
        _blackLayer.path        = path.CGPath;
        _blackLayer.lineWidth   = 2.0f;
        _blackLayer.fillColor   = [UIColor clearColor].CGColor;
        _blackLayer.strokeColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f].CGColor;
    }
    
    return _blackLayer;
}

- (CAShapeLayer *)whiteLayer {
    if (_whiteLayer == nil) {
        _whiteLayer = [CAShapeLayer layer];
        
        CGPoint center     = CGPointMake(kRadius, kRadius);
        CGFloat radius     = kRadius;
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle   = -M_PI_2 + M_PI * 2;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:YES];
        
        _whiteLayer.path        = path.CGPath;
        _whiteLayer.lineCap     = kCALineCapRound;
        _whiteLayer.lineWidth   = 2.0f;
        _whiteLayer.fillColor   = [UIColor clearColor].CGColor;
        _whiteLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    
    return _whiteLayer;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    self.whiteLayer.strokeEnd = progress;
}

@end
