//
//  Macro.h
//  WebService
//
//  Created by 朱广健 on 15/7/8.
//  Copyright (c) 2015年 rang. All rights reserved.
//

#ifndef WebService_Macro_h
#define WebService_Macro_h

#define RGBHEX(hex)         [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define mColorBackgroundGray        RGBHEX(0xfafafa)
#define mColorMainTint              RGBHEX(0x607d8b)
#define mColorWindowTint            RGBHEX(0xffffff)
#define mColorScheduleTop           RGBHEX(0xfafafa)
#define mColorScheduleLeft          RGBHEXA(0xa0a0a0, 0.5)
#define mColorScheduleLine          RGBHEX(0xd2d2d2)
#define mColorScheduleBackground    RGBHEX(0xf5f5f5)
#define mColorTitleGray             RGBHEX(0xa0a0a0)
#define mColorScheduleYellow        RGBHEX(0xffc107)

#define mColorSchedulePurple        RGBHEX(0xf48fb1)

#define LASTSELECTEDWEEK        @"lastSelectedWeek"

#endif
