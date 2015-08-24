//
//  XGridView.h
//  WebService
//
//  Created by 朱广健 on 15/7/9.
//  Copyright (c) 2015年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBaseGridView.h"

@interface XGridView : UIView <UIScrollViewDelegate>

@property id<XBaseGridViewDelegate> delegate;
@property UIScrollView *scrollView;

+ (XGridView *)gridViewWithDelegate:(id<XBaseGridViewDelegate>) delegate frame:(CGRect)frame;

- (void)invalidate;

@end

@interface XGridViewYLabel : UIView

+ (XGridViewYLabel*)labelForwidth:(int)width top:(int)x delegate:(id<XBaseGridViewDelegate>)deleagte;

@property UILabel * backgroundLabel;

@end

@interface XGridViewTopBar : UIView

+ (XGridViewTopBar*)topBarForHeight:(int)h delegate:(id<XBaseGridViewDelegate>)deleagte;

- (void)selectTopBarIcon:(int)which;

@property UILabel * foregroundLabel;
@property(weak, nonatomic) XBaseGridView *gidview;

@end
