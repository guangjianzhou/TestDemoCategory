//
//  NSDate+DateHelp.m
//  App
//
//  Created by lingyj on 14-7-10.
//  Copyright (c) 2014年 ShareMerge. All rights reserved.
//

#import "NSDate+help.h"

typedef enum{
    SUN,
    MON,
    TUES,
    WED,
    THUR,
    FRI,
    SAT
}WEEK;


@implementation NSDate (help)

#pragma mark - 获取时间
//时间戳（格式为yyyyMMddHHmmss）
+ (NSString *)getCurrentTimestamp
{
    return [self getCurrentTimestampWithDateformat:kDefaultFormat];
}

//时间戳（格式为yyyy-MM-dd HH:mm:ss.SSS）
+ (NSString *)getCurrentTimesWithMsec
{
    return [self getCurrentTimestampWithDateformat:@"yyyy-MM-dd HH:mm:ss.SSS"];
}

//时间戳(当前日期)
+ (NSString *)getCurrentDate
{
    return [self getCurrentTimestampWithDateformat:@"yyyyMMdd"];
}

//时间戳（格式自定）
+ (NSString *)getCurrentTimestampWithDateformat:(NSString *)format
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *nowTimeString = [formatter stringFromDate:now];
    return nowTimeString;
}

#pragma mark - 时间间隔计算
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSDate *)dateFromString:(NSString *)datestring withFormat:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format timeZone:(NSString *)timeZone
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    [dateFormat setDateFormat:format];
    NSDate* date = [dateFormat dateFromString:dateString];
    return date;
}

//+ (NSDate *)dateFromString:(NSString *)dateString
//{
//    return [NSDate dateFromString:dateString withFormat:kDefaultFormat];
//}

#pragma mark - 计算时间间隔
+ (NSInteger)daysFromDate:(NSDate *)date
{
    return [NSDate daysBetweenDate:date andDate:[NSDate date]];
}

+ (NSInteger)daysFromDateString:(NSString *)dateString
{
    NSDate *date = [NSDate dateFromString:dateString withFormat:kDefaultFormat];
    return [NSDate daysBetweenDate:date andDate:[NSDate date]];
}

+ (NSInteger)daysFromDateString:(NSString *)dateString withDateFomat:(NSString *)dateFormat
{
    return [NSDate daysBetweenDate:[NSDate dateFromString:dateString withFormat:dateFormat] andDate:[NSDate date]];
}

+ (NSInteger)daysBetween:(NSString *)date1 andDate:(NSString *)date2
{
    NSDate *d1 = [NSDate dateFromString:date1 withFormat:kDefaultFormat];
    NSDate *d2 = [NSDate dateFromString:date2 withFormat:kDefaultFormat];
    return [NSDate daysBetweenDate:d1 andDate:d2];
}

+ (NSInteger)daysBetween:(NSString *)date1 andDate:(NSString *)date2 dateFormat:(NSString *)format
{
    NSDate *d1 = [NSDate dateFromString:date1 withFormat:format];
    NSDate *d2 = [NSDate dateFromString:date2 withFormat:format];
    return [NSDate daysBetweenDate:d1 andDate:d2];
}

+ (NSInteger)daysBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger days = [comps day];
    return days;
}

+ (NSInteger)dateFromDate:(NSDate *)date intervalType:(IntervalType)type
{
    return [NSDate dateBetweenDate:[NSDate date] andDate:date intervalType:type];
}

+ (NSInteger)dateFromDateString:(NSString *)dateString intervalType:(IntervalType)type
{
    NSDate *date = [NSDate dateFromString:dateString withFormat:kDefaultFormat];
    return [NSDate dateBetweenDate:date andDate:[NSDate date] intervalType:type];
}

+ (NSInteger)dateFromDateString:(NSString *)dateString withDateFomat:(NSString *)dateFormat intervalType:(IntervalType)type
{
    NSDate *date = [NSDate dateFromString:dateString withFormat:dateFormat];
    return [NSDate dateBetweenDate:date andDate:[NSDate date] intervalType:type];
}

+ (NSInteger)dateBetween:(NSString *)date1 andDate:(NSString *)date2 intervalType:(IntervalType)type
{
    NSDate *d1 = [NSDate dateFromString:date1 withFormat:kDefaultFormat];
    NSDate *d2 = [NSDate dateFromString:date2 withFormat:kDefaultFormat];
    return [NSDate dateBetweenDate:d1 andDate:d2 intervalType:type];
}

+ (NSInteger)dateBetween:(NSString *)date1 andDate:(NSString *)date2 dateFormat:(NSString *)format intervalType:(IntervalType)type
{
    NSDate *d1 = [NSDate dateFromString:date1 withFormat:format];
    NSDate *d2 = [NSDate dateFromString:date2 withFormat:format];
    return [NSDate dateBetweenDate:d1 andDate:d2 intervalType:type];
}

+ (NSInteger)dateBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 intervalType:(IntervalType)type
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    switch (type)
    {
        case IntervalTypeEra:
        {
            unsigned int unitFlags = NSCalendarUnitEra;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
            return [comps era];
        }
        
        case IntervalTypeYear:
        {
            unsigned int unitFlags = NSCalendarUnitYear;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
            return [comps year];
        }
        
        case IntervalTypeMonth:
        {
            unsigned int unitFlags = NSCalendarUnitMonth;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
            return [comps month];
        }
        
        case IntervalTypeDay:
        {
            unsigned int unitFlags = NSCalendarUnitDay;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
            return [comps day];
        }
        
        case IntervalTypeHour:
        {
            unsigned int unitFlags = NSCalendarUnitHour;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
            return [comps hour];
        }
        
        case IntervalTypeMinute:
        {
            unsigned int unitFlags = NSCalendarUnitMinute;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
            return [comps minute];
        }
        
        case IntervalTypeSecond:
        {
            unsigned int unitFlags = NSCalendarUnitSecond;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1 toDate:date2 options:0];
            return [comps second];
        }
    }
    return 0;
}

+ (NSString *)compareDate:(NSDate *)date
{
    NSDate *today = [NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate *refDate = date;
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        NSString *todayTime = [NSDate stringFromDate:date withFormat:@"HH:mm"];
        return todayTime;
    }
    else if ([refDateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd"];
        NSString *str = [formatter stringFromDate:date];
        return str;
    }
}

+ (NSString *)intervalSinceNow:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsPast = [calendar components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger years = [compsNow year] - [compsPast year];
    NSInteger months = [compsNow month] - [compsPast month] + years * 12;
    NSInteger days = [compsNow day] - [compsPast day] + months * 30;
    NSInteger hours = [compsNow hour] - [compsPast hour] + days * 24;
    NSInteger minutes = [compsNow minute] - [compsPast minute] + hours * 60;
    
    if (minutes < 1) {
        return @"刚刚";
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%ld 分钟前", (long)minutes];
    } else if (hours < 24) {
        return [NSString stringWithFormat:@"%ld 小时前", (long)hours];
    } else if (hours < 48 && days == 1) {
        return @"昨天";
    } else if (days < 30) {
        return [NSString stringWithFormat:@"%ld 天前", (long)days];
    } else if (days < 60) {
        return @"一个月前";
    } else if (months < 12) {
        return [NSString stringWithFormat:@"%ld 个月前", (long)months];
    } else {
        NSArray *arr = [dateStr componentsSeparatedByString:@"T"];
        return [arr objectAtIndex:0];
    }
}


+ (NSString *)getOfWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps;// = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    switch ([comps weekday]) {
        case 1:
            return  @"星期日";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return @"";
    }
}

+ (NSString *)getOfWeekWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps;// = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    switch ([comps weekday]) {
        case 1:
            return  @"星期日";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return @"";
    }
}

//@[@"2015-05-25",@"2015-05-26",@"2015-05-27",@"2015-05-28"...]
+ (NSArray *)getWeekOfDaysWithDate:(NSDate *)date
{
    return [self currentWeekDays:date];
}

//方法有问题
+ (NSArray *)getWeekOfDaysWithDate1:(NSDate *)date
{
    NSArray *dateArray = [[NSDate stringFromDate:date withFormat:kDayFormat] componentsSeparatedByString:@"-"];
    int year = [[dateArray firstObject] intValue];
    int month = [dateArray[1] intValue];
    int day = [[dateArray lastObject] intValue];
    
    WEEK week = [self getWeekAtYear:year andMonth:month andDay:day];
    int week_int = [self getIntValueAtWeek:week];
    int startWeekEndDayCount = 7-week_int+1;
    
    NSMutableArray *days =  [NSMutableArray arrayWithCapacity:0];
    //这周开始日期day_
    for (int day_ = day-(7-startWeekEndDayCount);day_ < day; day_++)
    {
        int ayear = year;
        int amonth = month;
        int aday = day_;
        if (aday < 1)
        {
            aday = [self getMonthDaysAtYear:ayear andMonth:12]-(day-day_);
            amonth = (month - 1) > 1 ? month - 1 : 12;
            if (amonth != month && month == 1)
            {
                ayear = ayear - 1;
            }
        }
        [days addObject:[NSString stringWithFormat:@"%04d-%02d-%02d",ayear,amonth,aday]];
    }
    
    for (int day_ = day; day_ < day+startWeekEndDayCount; day_++)
    {
        int ayear = year;
        int amonth = month;
        int aday = day_;
        
        if (day_ > [self getMonthDaysAtYear:ayear andMonth:month])
        {
            aday = day_ - [self getMonthDaysAtYear:ayear andMonth:month];
            amonth = (month + 1) <= 12 ? month + 1 : (month + 1)-12;
            if (amonth != month && month == 12)
            {
                ayear = ayear + 1;
            }
        }
        [days addObject:[NSString stringWithFormat:@"%04d-%02d-%02d",ayear,amonth,aday]];
    }
    return [NSArray arrayWithArray:days];
}

+ (int)getIntValueAtWeek:(WEEK)week
{
    return (week == SUN ? 7:week);
}

+ (int)getMonthDaysAtYear:(int)year andMonth:(int)month
{
    int days = 0;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            days = 31;

            break;
        case 2:
            if ((year%4 == 0 && year%100 != 0) || year%400 == 0)
            {
                days = 29;
            }
            else
            {
                days = 28;
            }
            break;
            
        case 4:
        case 6:
        case 9:
        case 11:
            days = 30;
            break;
        default:
            break;
    }
    return days;
}

+ (WEEK)getWeekAtYear:(int)year andMonth:(int)month andDay:(int)day
{
    WEEK week = 0;
    int (*arr)[] = [self getNewMonth:month andYear:year];
    week = day+2*(*arr)[0]+3*((*arr)[0]+1)/5+(*arr)[1]+(*arr)[1]/4-(*arr)[1]/100+(*arr)[1]/400+1;
    free(*arr);
    return abs(week)%7;
}

+ (int(*)[])getNewMonth:(int)mon andYear:(int)ye
{
    int newmon = 0;
    int newyear = ye;
    if (mon>=3 && mon<=12)
    {
        newmon = mon;
    }
    else if(mon == 1)
    {
        newmon = 13;
        newyear = ye-1;
    }
    else if(mon == 2)
    {
        newmon = 14;
        newyear = ye-1;
    }
    int (*parr)[] = (int (*)[])malloc(2*sizeof(int));
    (*parr)[0] = newmon;
    (*parr)[1] = newyear;
    return parr;
}

//获取当前日期是第几个星期
+ (int)getWeekCountAtYear:(int)year andMonth:(int)month andDay:(int)day
{
    int day_ = day;
    int firstDay = 1;
    WEEK firstWeek = [self getWeekAtYear:year andMonth:month andDay:firstDay];
    int firstWeek_int = [self getIntValueAtWeek:firstWeek];
    int firstWeekEndDayCount = 7-firstWeek_int;
    int firstWeekEndDay = firstDay+firstWeekEndDayCount;
    int lastComDay = firstWeekEndDay;
    int weekCount = (day_<firstWeekEndDay ? 0 : 1);
    while (firstWeekEndDay+7 <= day_)
    {
        lastComDay = lastComDay+7;
        weekCount ++;
    }
    if ((day_-lastComDay)%7 != 0)
    {
        weekCount += 1;
    }
    return weekCount;
}

//获取年
+ (NSInteger)dateYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compt = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    return [compt year];
}

+ (NSInteger )dateDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compt = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    return [compt day];
}


+(NSInteger )dateMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compt = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    return [compt month];
}

+ (NSInteger)getWeekIndexForYearWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger count = [calendar ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:date];
    return count;
}

+ (BOOL)isSameWeekDate:(NSDate *)date1 withDate:(NSDate *)date2
{
    NSArray *weeks = [self getWeekOfDaysWithDate:date1];
    NSString *day2 = [NSDate stringFromDate:date2 withFormat:kDayFormat];
    return [weeks containsObject:day2];
}

#pragma mark 获取本周所有天数
// 本周日期字符串数组
+ (NSArray *)currentWeekDays:(NSDate *)currentDate
{
    NSMutableArray *array = [NSMutableArray array];
    // 获取今天星期几（数字）
    NSInteger today = [self weekDayWithDate:currentDate];
    for (int i = 0; i < 7; i++) {
        // 周一到周日七天距离今天的时间差（以秒为单位）
        double timeInterval = (i + 1 - today) * 24 * 60 * 60;
        // 周一到周日的DATE对象
        NSDate *date  = [NSDate dateWithTimeInterval:timeInterval sinceDate:currentDate];
        // 周一到周日的字符串对象
        NSString *dateStr = [NSDate stringFromDate:date withFormat:kDayFormat];
        // 添加到数组
        [array addObject:dateStr];
    }
    return array;
}

// 根据日期获取星期，返回数字（1~7）
+ (NSInteger)weekDayWithDate:(NSDate *)date
{
    // 得到日期那天星期几
    NSString *weekday = [self getOfWeekWithDate:date];
    // 将星期转换成对应数字
    return [self weekNumberWithWeekDayString:weekday];
}

// 将星期转换成数字（星期一：1， 星期二：2， 星期三：3 ...）
+ (NSInteger)weekNumberWithWeekDayString:(NSString *)weekDay
{
    if ([weekDay isEqualToString:@"星期一"]) return 1;
    if ([weekDay isEqualToString:@"星期二"]) return 2;
    if ([weekDay isEqualToString:@"星期三"]) return 3;
    if ([weekDay isEqualToString:@"星期四"]) return 4;
    if ([weekDay isEqualToString:@"星期五"]) return 5;
    if ([weekDay isEqualToString:@"星期六"]) return 6;
    if ([weekDay isEqualToString:@"星期日"]) return 7;
    return 0;
}

+ (NSString *)string_yyyy_MM_dd_HH_mm_ss:(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return  [dateFormatter stringFromDate:date];
}

@end
