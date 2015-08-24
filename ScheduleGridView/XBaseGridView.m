//
//  XBaseGridView.m
//  WebService
//
//  Created by 朱广健 on 15/7/9.
//  Copyright (c) 2015年 rang. All rights reserved.
//

#import "XBaseGridView.h"
#import "AppDelegate.h"

@implementation XBaseGridView
{
    NSInteger row, column;
    int viewHeight;
    int selected;
    NSArray *weekDays;
    NSArray *colorArray;
}

+ (XBaseGridView *)baseGridViewWithDelegate:(id<XBaseGridViewDelegate>)delegate
{
    XBaseGridView *baseView = [XBaseGridView new];
    baseView.delegate = delegate;
    [baseView initView];
    return baseView;
}

- (void)initView
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    selected = (int)[ud integerForKey:LASTSELECTEDWEEK];
    if (selected == 0)  selected = 1;
    row = 0;
    column = 0;
    _viewWidth = 0;
    viewHeight = 0;
    _topBarHeight1 = 40;
    _topBarHeight2 = 40;
    _leftBarWidth = 40;
    weekDays = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    colorArray = @[mColorMainTint, mColorSchedulePurple, mColorScheduleYellow];
    
    if ([self validate])
    {
        row = [_delegate numberOfRow];
        column = [_delegate numberOfColumn];
        
        for (int i=0;i<column;i++)
        {
            _viewWidth += [_delegate widthForCellInColumn:i];
        }
        for (int i=0;i<row;i++)
        {
            viewHeight += [_delegate heightForCellInRow:i];
        }
        self.frame = CGRectMake(0, 0, _viewWidth+_leftBarWidth, viewHeight+_topBarHeight1+_topBarHeight2+1);
        self.backgroundColor = mColorScheduleBackground;
    }
    
}

- (void)drawRect:(CGRect)rect
{
    if (![self validate])    return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    
    [mColorScheduleLine setStroke];
    
    // 画线
    int topBarHeight = _topBarHeight1+_topBarHeight2;
    CGContextMoveToPoint(context, 0, topBarHeight);
    CGContextAddLineToPoint(context, _viewWidth+_leftBarWidth, topBarHeight);
    CGContextDrawPath(context, kCGPathStroke);
    
    for (int i=1;i<=row+1;i++)
    {
        int y = topBarHeight+i*[_delegate heightForCellInRow:i-1];
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, _viewWidth+_leftBarWidth, y);
        CGContextDrawPath(context, kCGPathStroke);
    }
    // 填充top bar
    CGContextAddRect(context, CGRectMake(0, 0, _viewWidth+_leftBarWidth, topBarHeight-1));
    [mColorScheduleTop setFill];
    CGContextDrawPath(context, kCGPathFill);
    // 分割线
    CGContextMoveToPoint(context, 0, _topBarHeight1);
    CGContextAddLineToPoint(context, _viewWidth+_leftBarWidth, _topBarHeight1);
    CGContextDrawPath(context, kCGPathStroke);
    // x2标签
    float h = _topBarHeight2;
    for (int i=0;i<column;i++)
    {
        NSString *text = [_delegate xLabelStringForIndex:i];
        NSDictionary *attr = @{NSFontAttributeName              :   [UIFont boldSystemFontOfSize:LABELFONTSIZE],
                               NSForegroundColorAttributeName   :   mColorTitleGray};
        float w = [_delegate widthForCellInColumn:i];
        CGRect rect = [text boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attr
                                         context:nil];
        rect.origin = CGPointMake(_leftBarWidth+i*w+(w-rect.size.width)/2, _topBarHeight1+(h-rect.size.height)/2);
        [text drawInRect:rect withAttributes:attr];
    }
    
    [self drawCourse:selected];
}

- (void)selectWeek:(int)which
{
    selected = which;
    [self setNeedsDisplay];
}

- (void)invalidate
{
    [self setNeedsDisplay];
}

// 画课程
- (void)drawCourse:(int)week
{
    if (week < 0)  return;
    
    NSArray *schedules = [_delegate arrayForCourses];
    for (int i=0;i<schedules.count;i++)
    {
        NSDictionary *course = [schedules objectAtIndex:i];
        NSString *courseName = [course objectForKey:@"courseName"];
        NSString *teacher = [course objectForKey:@"teacherName"];
        NSString *place = [course objectForKey:@"place"];
        NSString *sectionNumber = [course objectForKey:@"sectionNumber"];
        NSString *weekDay = [course objectForKey:@"weekDay"];
        NSString *weekNumber = [course objectForKey:@"weekNumber"];
        NSInteger color = [[course objectForKey:@"color"] integerValue];
        UIColor *c = colorArray[color];
//        NSString *info = [course objectForKey:@"info"];
        
        NSArray *weeks = [weekNumber componentsSeparatedByString:@"|"];
        BOOL isHere = NO;
        for (int i=0;i<weeks.count;i++)
        {
            if ([weeks[i] integerValue] == week)
            {
                isHere = YES;
                break;
            }
        }
        if (!isHere)    continue;
        
        for (int i=0;i<weekDays.count;i++)
        {
            if ([weekDay containsString:weekDays[i]])
            {
                weekDay = [NSString stringWithFormat:@"%i", i];
                break;
            }
        }
        
        NSArray *sections = [sectionNumber componentsSeparatedByString:@"|"];
        
        int x = _leftBarWidth+2;
        int y = _topBarHeight1 + _topBarHeight2;
        int width = [_delegate widthForCellInColumn:[weekDay intValue]]-2;
        int height = 0;
        for (int j=0;j<[weekDay intValue];j++)
        {
            x += [_delegate widthForCellInColumn:j];
        }
        for (int j=0;j<[sections[0] integerValue]-1;j++)
        {
            y += [_delegate heightForCellInRow:[sections[0] integerValue]-1];
        }
        for (int j=0;j<sections.count;j++)
        {
            height += [_delegate heightForCellInRow:[sections[0] integerValue]-1];
        }
        // 画背景
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddRect(context, CGRectMake(x, y, width, height));
        [c setFill];
        CGContextDrawPath(context, kCGPathFill);
        // 画背景边框
        CGContextAddRect(context, CGRectMake(x, y, width, height));
        [mColorScheduleLine setStroke];
        CGContextDrawPath(context, kCGPathStroke);
        // 画文字
        NSString *text = [NSString stringWithFormat:@"%@\r%@", teacher, place];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentLeft;
        NSDictionary *attr2 = @{NSFontAttributeName              :   [UIFont boldSystemFontOfSize:DETAILFONTSIZE],
                               NSForegroundColorAttributeName   :   [UIColor whiteColor],
                               NSParagraphStyleAttributeName    :   paragraph};
        NSDictionary *attr1 = @{NSFontAttributeName              :   [UIFont boldSystemFontOfSize:SCHEDULEFONTSIZE],
                                NSForegroundColorAttributeName   :   [UIColor whiteColor],
                                NSParagraphStyleAttributeName    :   paragraph};
        NSAttributedString *text2 = [[NSAttributedString alloc] initWithString:text attributes:attr2];
        NSAttributedString *text1 = [[NSAttributedString alloc] initWithString:courseName attributes:attr1];
        NSMutableAttributedString *_text = [[NSMutableAttributedString alloc] init];
        [_text appendAttributedString:text1];
        [_text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\r\r"]];
        [_text appendAttributedString:text2];
        CGRect rect = [_text boundingRectWithSize:CGSizeMake(width-20, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                         context:nil];
        rect.origin.x = x + 10;
        rect.origin.y = y + 10;
        [_text drawInRect:rect];
    }
}

- (BOOL)validate
{
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfRow)]
        && [_delegate respondsToSelector:@selector(numberOfColumn)]
        && [_delegate respondsToSelector:@selector(widthForCellInColumn:)]
        && [_delegate respondsToSelector:@selector(heightForCellInRow:)]
        && [_delegate respondsToSelector:@selector(numberOfTopBarLabels)]
        && [_delegate respondsToSelector:@selector(topBarLabelStringForIndex:)]
        && [_delegate respondsToSelector:@selector(arrayForCourses)])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
