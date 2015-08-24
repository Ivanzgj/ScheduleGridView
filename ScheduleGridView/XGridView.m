//
//  XGridView.m
//  WebService
//
//  Created by 朱广健 on 15/7/9.
//  Copyright (c) 2015年 rang. All rights reserved.
//

#import "XGridView.h"

@implementation XGridView
{
    XBaseGridView *gridView;
    UILabel *weekGestureLabel;
    XGridViewYLabel *yLabel;
    XGridViewTopBar *topBar;
}

+ (XGridView *)gridViewWithDelegate:(id<XBaseGridViewDelegate>)delegate frame:(CGRect)frame
{
    XGridView *view = [XGridView new];
    view.delegate = delegate;
    [view initView:frame];
    return view;
}

- (void)initView:(CGRect)frame
{
    // 课表格子
    gridView = [XBaseGridView baseGridViewWithDelegate:_delegate];
    self.frame = frame;
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.contentSize = gridView.frame.size;
    [self addSubview:_scrollView];
    [_scrollView addSubview:gridView];
    _scrollView.bounces = NO;_scrollView.delegate = self;
    
    // topbar
    topBar = [XGridViewTopBar topBarForHeight:gridView.topBarHeight1 delegate:_delegate];
    topBar.gidview = gridView;
    frame = topBar.frame;
    frame.size.width = _scrollView.frame.size.width;
    UIScrollView *scv = [[UIScrollView alloc] initWithFrame:frame];
    scv.contentSize = topBar.frame.size;
    [scv addSubview:topBar];
    [scv addSubview:topBar.foregroundLabel];
    [self addSubview:scv];
    
    // ylabel
    yLabel = [XGridViewYLabel labelForwidth:gridView.leftBarWidth top:gridView.topBarHeight1+gridView.topBarHeight2 delegate:_delegate];
    [self addSubview:yLabel.backgroundLabel];
    [self addSubview:yLabel];
}

- (void)invalidate
{
    [gridView invalidate];
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int y = scrollView.contentOffset.y;
    int x = scrollView.contentOffset.x;
    
    CGRect frame = yLabel.frame;
    frame.origin.y = gridView.topBarHeight1+gridView.topBarHeight2-y;
    yLabel.frame = frame;
    yLabel.backgroundLabel.frame = frame;
    
    if (x < gridView.leftBarWidth)  yLabel.backgroundLabel.alpha = ((float)x)/(float)gridView.leftBarWidth*0.4;
    else                            yLabel.backgroundLabel.alpha = 0.4;
    
    if (y < gridView.topBarHeight1)
    {
        CGRect frame = topBar.frame;
        frame.origin.y = -y;
        topBar.frame = frame;
    }
    else
    {
        CGRect frame = topBar.frame;
        frame.origin.y = -gridView.topBarHeight1;
        topBar.frame = frame;
    }
//    NSLog(@"alpha:%f", yLabel.backgroundLabel.alpha);
}

@end

#pragma mark - 

@implementation XGridViewYLabel
{
    int _width;
    int _top;
    int viewHeight;
    id<XBaseGridViewDelegate> _delegate;
    NSInteger row;
}

+ (XGridViewYLabel*)labelForwidth:(int)width top:(int)x delegate:(id<XBaseGridViewDelegate>)deleagte
{
    XGridViewYLabel *label = [XGridViewYLabel new];
    [label initForwidth:width top:x delegate:deleagte];
    return label;
}

- (void)initForwidth:(int)w top:(int)x delegate:(id<XBaseGridViewDelegate>)deleagte
{
    _width = w;
    _top = x;
    _delegate = deleagte;
    viewHeight = 0;
    
    row = [_delegate numberOfRow];
    for (int i=0;i<row;i++)
    {
        viewHeight += [_delegate heightForCellInRow:i];
    }
    self.frame = CGRectMake(0, _top, _width, viewHeight);
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundLabel = [[UILabel alloc] initWithFrame:self.frame];
    _backgroundLabel.backgroundColor = mColorSchedulePurple;
}

- (void)drawRect:(CGRect)rect
{
    float h = 0;
    for (int i=0;i<row;i++)
    {
        NSString *text = [_delegate yLabelStringForIndex:i];
        NSDictionary *attr = @{NSFontAttributeName              :   [UIFont boldSystemFontOfSize:LABELFONTSIZE],
                               NSForegroundColorAttributeName   :   mColorTitleGray};
        float h1 = [_delegate heightForCellInRow:i];
        CGRect rect = [text boundingRectWithSize:CGSizeMake(_width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attr
                                         context:nil];
        rect.origin = CGPointMake((_width-rect.size.width)/2, h+(h1-rect.size.height)/2);
        [text drawInRect:rect withAttributes:attr];
        h += [_delegate heightForCellInRow:i];
    }
}

@end

#pragma mark -

@implementation XGridViewTopBar
{
    int _width;
    int _height;
    int _x;
    int _sep;
    id<XBaseGridViewDelegate> _delegate;
    int selected;
}

+ (XGridViewTopBar*)topBarForHeight:(int)h delegate:(id<XBaseGridViewDelegate>)deleagte
{
    XGridViewTopBar *label = [XGridViewTopBar new];
    [label initForHeight:h delegate:deleagte];
    return label;
}

- (void)initForHeight:(int)h delegate:(id<XBaseGridViewDelegate>)deleagte
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    selected = (int)[ud integerForKey:LASTSELECTEDWEEK];
    if (selected == 0)  selected = 1;
    
    _height = h;
    _delegate = deleagte;
    _x = 10;
    _sep = 20;
    _width = (int)(_x + [_delegate numberOfTopBarLabels] * (_height-4) +_sep * ([_delegate numberOfTopBarLabels]-1));
    
    self.frame = CGRectMake(0, 0, _width, _height);
    self.backgroundColor = [UIColor clearColor];
    
    // 检测手势
    _foregroundLabel = [[UILabel alloc] initWithFrame:self.frame];
    _foregroundLabel.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWeekLabel:)];
    _foregroundLabel.userInteractionEnabled = YES;
    [_foregroundLabel addGestureRecognizer:tap];
}

- (void)drawRect:(CGRect)rect
{
    float h = _height;
    float w = (_width - _x) / [_delegate numberOfTopBarLabels];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    for (int i=0;i<[_delegate numberOfTopBarLabels];i++)
    {
        NSString *text = [_delegate topBarLabelStringForIndex:i];
        NSDictionary *attr = @{NSFontAttributeName              :   [UIFont boldSystemFontOfSize:LABELFONTSIZE],
                               NSForegroundColorAttributeName   :   mColorTitleGray};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attr
                                         context:nil];
        rect.origin = CGPointMake(_x+i*w+(w-rect.size.width)/2, (h-rect.size.height)/2);
        [text drawInRect:rect withAttributes:attr];
    }
    
    [self drawSelectCircle:selected];
}

// 在周次上画圈
- (void)drawSelectCircle:(int)which
{
    if (which < 0)  return;
    
    which -= 1;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    
    NSString *text = [_delegate topBarLabelStringForIndex:which];
    NSDictionary *attr = @{NSFontAttributeName              :   [UIFont boldSystemFontOfSize:LABELFONTSIZE],
                           NSForegroundColorAttributeName   :   [UIColor whiteColor]};
    float w = _width / [_delegate numberOfTopBarLabels];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(w, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    
    CGPoint center = CGPointMake(_x+(which+0.5)*w, _height/2);
    float radius = rect.size.height*0.6;
    CGContextAddArc(context, center.x, center.y, radius, 0.0, M_PI*2.0, YES);
    
    [[UIColor clearColor] setStroke];
    [mColorScheduleYellow setFill];
    CGContextDrawPath(context, kCGPathFill);
    
    rect.origin = CGPointMake(_x+which*w+(w-rect.size.width)/2, (_height-rect.size.height)/2);
    [[UIColor whiteColor] setStroke];
    [[UIColor whiteColor] setFill];
    [text drawInRect:rect withAttributes:attr];
}

- (void)selectTopBarIcon:(int)which
{
    selected = which;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:selected forKey:LASTSELECTEDWEEK];
    [ud synchronize];
    [self setNeedsDisplay];
    [_gidview selectWeek:which];
}

- (void)tapWeekLabel:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationOfTouch:0 inView:_foregroundLabel];
    int x = point.x;
    int sum = _x;
    for (int i=1;i<=[_delegate numberOfTopBarLabels];i++)
    {
        if (x < sum)    return;
        sum += _width / [_delegate numberOfTopBarLabels];
        if (x < sum)
        {
            if (i == selected)  return;
            [self selectTopBarIcon:i];
            return;
        }
    }
}

@end
