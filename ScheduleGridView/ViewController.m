//
//  ViewController.m
//  ScheduleGridView
//
//  Created by 朱广健 on 15/8/24.
//  Copyright (c) 2015年 朱广健. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *weekLabels;
    NSArray *xLabels;
    NSArray *yLabels;
    NSArray *scheduleArray;
    XGridView *scheduleTable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scheduleArray = [NSArray array];
    
    weekLabels = [NSMutableArray array];
    for (int i=1;i<=20;i++)      [weekLabels addObject:[NSString stringWithFormat:@"%i", i]];
    xLabels = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    yLabels = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    
    CGRect frame = self.view.bounds;
    scheduleTable = [XGridView gridViewWithDelegate:self frame:frame];
    [self.view addSubview:scheduleTable];
    
    scheduleArray = [self getCourseFromDatabase];
    [scheduleTable invalidate];
}

- (NSMutableArray*)getCourseFromDatabase
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *course1 = [NSMutableDictionary dictionary];
    [course1 setObject:@"不告诉你" forKey:@"courseName"];
    [course1 setObject:@"你猜" forKey:@"teacherName"];
    [course1 setObject:@"东九" forKey:@"place"];
    [course1 setObject:@"1|2" forKey:@"sectionNumber"];
    [course1 setObject:@"星期三" forKey:@"weekDay"];
    [course1 setObject:@"1|2|3|4|5|6|7|8" forKey:@"weekNumber"];
    [course1 setObject:@(0) forKey:@"color"];
    
    NSMutableDictionary *course2 = [NSMutableDictionary dictionary];
    [course2 setObject:@"不告诉你" forKey:@"courseName"];
    [course2 setObject:@"你猜" forKey:@"teacherName"];
    [course2 setObject:@"东九" forKey:@"place"];
    [course2 setObject:@"5|6" forKey:@"sectionNumber"];
    [course2 setObject:@"星期五" forKey:@"weekDay"];
    [course2 setObject:@"1|2|3|4|5|6|7|8" forKey:@"weekNumber"];
    [course2 setObject:@(1) forKey:@"color"];
    
    NSMutableDictionary *course3 = [NSMutableDictionary dictionary];
    [course3 setObject:@"不告诉你" forKey:@"courseName"];
    [course3 setObject:@"你猜" forKey:@"teacherName"];
    [course3 setObject:@"东九" forKey:@"place"];
    [course3 setObject:@"1|2|3|4" forKey:@"sectionNumber"];
    [course3 setObject:@"星期二" forKey:@"weekDay"];
    [course3 setObject:@"4|5|6|7|8|9|10|11|12" forKey:@"weekNumber"];
    [course3 setObject:@(2) forKey:@"color"];
    
    [array addObject:course1];
    [array addObject:course2];
    [array addObject:course3];
    return array;
}

#pragma mark - XGridView delegate

- (NSInteger)numberOfColumn
{
    return 7;
}

- (NSInteger)numberOfRow
{
    return 12;
}

- (float)widthForCellInColumn:(NSInteger)col
{
    return 80;
}

- (float)heightForCellInRow:(NSInteger)row
{
    return 60;
}

- (NSString *)topBarLabelStringForIndex:(NSInteger)index
{
    return [weekLabels objectAtIndex:index];
}

- (NSString *)xLabelStringForIndex:(NSInteger)index
{
    return [xLabels objectAtIndex:index];
}

- (NSString *)yLabelStringForIndex:(NSInteger)index
{
    return [yLabels objectAtIndex:index];
}

- (NSInteger)numberOfTopBarLabels
{
    return weekLabels.count;
}

- (NSArray *)arrayForCourses
{
    return scheduleArray;
}

@end
