//
//  GLPhotoBrowser.m
//  Pods
//
//  Created by gaoli on 2016/12/13.
//
//

#import "GLPhotoBrowser.h"
#import "GLPhotoBrowserViewModel.h"
#import "GLPhotoBrowserViewController.h"

@implementation GLPhotoBrowser

- (void)initWithThumbnails:(NSArray *)thumbnails URLs:(NSArray *)URLs index:(NSInteger)index {
    UIImageView *thumbnail = [thumbnails objectAtIndex:index];
    
    if (thumbnail.image == nil) {
        return;
    }
    
    NSMutableArray *photoDOs = [NSMutableArray array];
    
    for (int i = 0; i < thumbnails.count; i++) {
        GLPhotoDO *photoDO = [[GLPhotoDO alloc] init];
        
        photoDO.url       = [URLs       objectAtIndex:i];
        photoDO.thumbnail = [thumbnails objectAtIndex:i];
        
        [photoDOs addObject:photoDO];
    }
    
    GLPhotoBrowserViewModel      *photoBrowserViewModel      = [[GLPhotoBrowserViewModel      alloc] initWithData:photoDOs index:index];
    GLPhotoBrowserViewController *photoBrowserViewController = [[GLPhotoBrowserViewController alloc] init];
    
    photoBrowserViewController.viewModel = photoBrowserViewModel;
    
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:photoBrowserViewController animated:NO completion:nil];
}

@end
