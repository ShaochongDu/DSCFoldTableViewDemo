//
//  FolderHeaderView.h
//  DSCFoldTableViewDemo
//
//  Created by Caxa on 16/1/12.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FolderHeaderView;

@protocol FolderHeaderViewDelegate <NSObject>
//  点击header视图 事件
- (void)headerViewDidTaped:(FolderHeaderView *)headerView sectionIndex:(NSInteger) sectionIndex;

@end

@interface FolderHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign) id<FolderHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImgView;

@property (nonatomic, assign) BOOL isSectionOpen;    //  当前section是否已打开
@property (nonatomic, assign) NSInteger sectionIndex;   //  当前的section值

@end
