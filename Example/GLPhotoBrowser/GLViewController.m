//
//  GLViewController.m
//  GLPhotoBrowser
//
//  Created by 高力 on 05/04/2016.
//  Copyright (c) 2016 高力. All rights reserved.
//

#import "GLViewController.h"
#import "GLCollectionViewCell.h"
#import "GLPhotoBrowserViewModel.h"
#import "GLPhotoBrowserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface GLViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray                      *middleUrlArray;
@property (nonatomic, strong) UICollectionView             *collectionView;
@property (nonatomic, strong) GLPhotoBrowserViewModel      *photoBrowserViewModel;
@property (nonatomic, strong) GLPhotoBrowserViewController *photoBrowserViewController;

@end

@implementation GLViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title          = @"首页";
        self.middleUrlArray = @[@"http://image.tianjimedia.com/uploadImages/2015/343/21/EZ1YHO659YV8_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/52/FB7GR8II5GS5_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/18/52E10034H217_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/57/7UZWDIG9M922_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/13/O5A4WH50VBS8_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/39/49O09SDO2RC2_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/05/W1X2E3JY2N4G_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/09/057LJ5B49V79_680x500.jpg",
                                @"http://image.tianjimedia.com/uploadImages/2015/343/48/952B2U4K05C7_680x500.jpg"];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
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
        [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:self.middleUrlArray[indexPath.row]]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

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
