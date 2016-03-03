//
//  NSDate+DateHelp.h
//  App
//
//  Created by lingyj on 14-7-10.
//  Copyright (c) 2014年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, IntervalType) {
    IntervalTypeEra,
    IntervalTypeYear,
    IntervalTypeMonth,
    IntervalTypeDay,
    IntervalTypeHour,
    IntervalTypeMinute,
    IntervalTypeSecond,
};

#define CurrentDateWithFormat(dateFormat)      [NSDate getCurrentTimestampWithDateformat : dateFormat]
#define DateFromString(dateString, dateFormat) [NSDate dateFromString : dateString withFormat : dateFormat]
#define StringFromDate(date, dateFormat)       [NSDate stringFromDate : date withFormat : dateFormat]
#define DaysBetween(date1, date2)              [NSDate daysBetween : date1 andDate : date2]

#define kDefaultFormat                  @"yyyyMMddHHmmss"
#define kDefaultFormat2                 @"yyyyMMddHHmmssSSS"
#define kDatabaseDateFormat             @"yyyy-MM-dd HH:mm:ss"
#define kDatabaseDateFormatWithTimeZone @"yyyy-MM-dd HH:mm:ss Z"
#define kDatabaseDateFormatWithSecond   @"yyyy-MM-dd HH:mm"
#define kMsecFormat                     @"yyyy-MM-dd HH:mm:ss.SSS"
#define kDayFormat                      @"yyyy-MM-dd"
#define kDayFormat2                     @"yy-MM-dd"
#define khourAndMinFormat               @"HH:mm"
#define khourMinSecondFormat            @"HH:mm:ss"
#define kDateAndMinisFormat             @"yyyy-MM-dd HH:mm"

#define kTimeFormat                     @"HH:mm:ss"

@interface NSDate (DateHelp)

//时间戳（格式为yyyyMMddHHmmss）
+ (NSString *)getCurrentTimestamp;

//时间戳 (格式为yyyy-MM-dd HH:mm:ss.SSS)
+ (NSString *)getCurrentTimesWithMsec;

//时间戳(当前日期)
+ (NSString *)getCurrentDate;

+ (NSString *)getCurrentTimestampWithDateformat:(NSString *)format;
//某一个时间到当前时间的天数
+ (NSInteger)daysFromDate:(NSDate *)date;
+ (NSInteger)daysFromDateString:(NSString *)dateString;
+ (NSInteger)daysFromDateString:(NSString *)dateString withDateFomat:(NSString *)dateFormat;

+ (NSInteger)daysBetween:(NSString *)date1 andDate:(NSString *)date2;
+ (NSInteger)daysBetween:(NSString *)date1 andDate:(NSString *)date2 dateFormat:(NSString *)format;
+ (NSInteger)daysBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;

+ (NSInteger)dateFromDate:(NSDate *)date intervalType:(IntervalType)type;
+ (NSInteger)dateFromDateString:(NSString *)dateString intervalType:(IntervalType)type;
+ (NSInteger)dateFromDateString:(NSString *)dateString withDateFomat:(NSString *)dateFormat intervalType:(IntervalType)type;

+ (NSInteger)dateBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 intervalType:(IntervalType)type;
+ (NSInteger)dateBetween:(NSString *)date1 andDate:(NSString *)date2 intervalType:(IntervalType)type;
+ (NSInteger)dateBetween:(NSString *)date1 andDate:(NSString *)date2 dateFormat:(NSString *)format intervalType:(IntervalType)type;

//string格式化为date
//+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;
//string格式化为date 带时区
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format timeZone:(NSString *)timeZone;

//date 转化为string
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

+ (NSString *)string_yyyy_MM_dd_HH_mm_ss:(NSString *)timeString;

//判断今天、昨天 还是日期
+ (NSString *)compareDate:(NSDate *)date;

//给个date 返回星期几
+ (NSString *)getOfWeek;
+ (NSString *)getOfWeekWithDate:(NSDate *)date;

//给个date 返回本周所有日期str
+ (NSArray *)getWeekOfDaysWithDate:(NSDate *)date;
//返回这周在今年的index
+ (NSInteger)getWeekIndexForYearWithDate:(NSDate *)date;

//判断两个date 是否处于同一周
+ (BOOL)isSameWeekDate:(NSDate *)date1 withDate:(NSDate *)date2;
@end
