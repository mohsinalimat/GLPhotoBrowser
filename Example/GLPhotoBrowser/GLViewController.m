//
//  GLViewController.m
//  GLPhotoBrowser
//
//  Created by gaoli on 05/04/2016.
//  Copyright (c) 2016 gaoli. All rights reserved.
//

#import "GLViewController.h"
#import "GLCollectionViewCell.h"
#import "GLPhotoBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface GLViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray          *smallImageURLs;
@property (nonatomic, strong) NSArray          *largeImageURLs;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation GLViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title          = @"首页";
        
        self.smallImageURLs = @[@"http://image.tianjimedia.com/uploadImages/2015/343/21/EZ1YHO659YV8_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/52/FB7GR8II5GS5_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/18/52E10034H217_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/57/7UZWDIG9M922_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/13/O5A4WH50VBS8_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/39/49O09SDO2RC2_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/05/W1X2E3JY2N4G_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/09/057LJ5B49V79_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/48/952B2U4K05C7_680x500.jpg"];
        
        self.largeImageURLs = @[@"http://image.tianjimedia.com/uploadImages/2015/343/21/EZ1YHO659YV8.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/52/FB7GR8II5GS5.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/18/52E10034H217.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/57/7UZWDIG9M922.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/13/O5A4WH50VBS8.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/39/49O09SDO2RC2.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/05/W1X2E3JY2N4G.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/09/057LJ5B49V79.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/48/952B2U4K05C7.jpg"];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        
        [imageCache clearDisk];
        [imageCache clearMemory];
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLCollectionViewCell" forIndexPath:indexPath];
    
    if (cell) {
        cell.thumbnail.tag = 1000 + indexPath.row;
        
        [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:self.smallImageURLs[indexPath.row]]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *URLs       = [NSMutableArray array];
    NSMutableArray *thumbnails = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        [URLs       addObject:[NSURL URLWithString:[self.largeImageURLs objectAtIndex:i]]];
        [thumbnails addObject:[self.view viewWithTag:1000 + i]];
    }
    
    [[GLPhotoBrowser alloc] initWithThumbnails:thumbnails URLs:URLs index:indexPath.row];
}

#pragma mark - getters and setters

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.itemSize                = CGSizeMake(80.0f, 80.0f);
        flowLayout.minimumLineSpacing      = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        
        CGRect frame = {{(SCREEN_W - 260.0f) / 2, 74.0f}, {260.0f, 260.0f}};
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[GLCollectionViewCell class] forCellWithReuseIdentifier:@"GLCollectionViewCell"];
    }
    
    return _collectionView;
}

@end
