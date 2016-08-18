//
//  FolderHeaderView.m
//  DSCFoldTableViewDemo
//
//  Created by Caxa on 16/1/12.
//  Copyright © 2016年 Shaochong Du. All rights reserved.
//

#import "FolderHeaderView.h"

@implementation FolderHeaderView

-(void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    [self addGestureRecognizer:tap];
}

-(void)setIsSectionOpen:(BOOL)isSectionOpen
{
    if (isSectionOpen) {
        self.rightArrowImgView.transform = CGAffineTransformMakeRotation(0);
    } else {
        self.rightArrowImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
}

#pragma mark - tap gesture
- (void)selfTap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"tip:headerViewDidTaped");
    if ([self.delegate respondsToSelector:@selector(headerViewDidTaped:sectionIndex:)]) {
        [self.delegate headerViewDidTaped:self sectionIndex:self.sectionIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
