//
//  XBaseGridView.h
//  WebService
//
//  Created by 朱广健 on 15/7/9.
//  Copyright (c) 2015年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

#define LABELFONTSIZE       16.f
#define SCHEDULEFONTSIZE    12.f
#define DETAILFONTSIZE      10.f

@protocol XBaseGridViewDelegate <NSObject>

- (float)heightForCellInRow:(NSInteger)row;
- (float)widthForCellInColumn:(NSInteger)col;
- (NSInteger)numberOfRow;
- (NSInteger)numberOfColumn;
- (NSString *)topBarLabelStringForIndex:(NSInteger)index;
- (NSString *)xLabelStringForIndex:(NSInteger)index;
- (NSString *)yLabelStringForIndex:(NSInteger)index;
- (NSArray *)arrayForCourses;
- (NSInteger)numberOfTopBarLabels;

@end

@interface XBaseGridView : UIView

+ (XBaseGridView *)baseGridViewWithDelegate:(id<XBaseGridViewDelegate>)delegate;

@property id<XBaseGridViewDelegate> delegate;
@property int topBarHeight1;
@property int topBarHeight2;
@property int leftBarWidth;
@property int viewWidth;

- (void)selectWeek:(int)which;
- (void)invalidate;

@end


