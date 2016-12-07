//
//  GLPhotoBrowserViewModel.h
//  Pods
//
//  Created by gaoli on 16/5/6.
//
//

#import <Foundation/Foundation.h>
#import "GLPhotoDO.h"

@interface GLPhotoBrowserViewModel : NSObject

@property (nonatomic, assign) NSInteger       index;
@property (nonatomic, assign) NSInteger       count;
@property (nonatomic, strong) NSMutableArray *photoDOs;

- (id)initWithData:(NSMutableArray *)photoDOs index:(NSInteger)index;

@end
