//
//  Manager.m
//  Haonz
//
//  Created by gaojindan on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Manager.h"

static NSMutableDictionary* calendarDic;
static NSMutableDictionary* calendarryDic;
static NSMutableDictionary* calendarryearDic;
static NSArray *chineseMonths;
static NSArray *chineseDays;
static AVAudioPlayer* audioPlayer;
static NSArray *cShuXiang;

@implementation Manager
+ (void)init
{
    if (![FILEMANAGER fileExistsAtPath:DIR_ImageCache]) {
        [FILEMANAGER createDirectoryAtPath:DIR_ImageCache withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![FILEMANAGER fileExistsAtPath:DIR_BIRTHDAY_GREETINGCARDS]) {
        [FILEMANAGER createDirectoryAtPath:DIR_BIRTHDAY_GREETINGCARDS withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![FILEMANAGER fileExistsAtPath:DIR_BIRTHDAY_LOGO]) {
        [FILEMANAGER createDirectoryAtPath:DIR_BIRTHDAY_LOGO withIntermediateDirectories:YES attributes:nil error:nil];
    }
    chineseMonths=[[NSArray alloc]initWithObjects:
                   @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                   @"九月", @"十月", @"冬月", @"腊月", nil];
    
    chineseDays=[[NSArray alloc]initWithObjects:
                 @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                 @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                 @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    //属相名称
    cShuXiang = [[NSArray alloc]initWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    NSString* str = [[NSBundle mainBundle] pathForResource:@"calendar" ofType:@"plist"];
    calendarDic = [[NSMutableDictionary alloc]initWithContentsOfFile:str];
    
    str = [[NSBundle mainBundle] pathForResource:@"calendarry" ofType:@"plist"];
    calendarryDic = [[NSMutableDictionary alloc]initWithContentsOfFile:str];
    
    str = [[NSBundle mainBundle] pathForResource:@"calendarryear" ofType:@"plist"];
    calendarryearDic = [[NSMutableDictionary alloc]initWithContentsOfFile:str];
}
+ (NSArray*)getChineseMonths
{
    return chineseMonths;
}
+ (NSArray*)getChineseDays
{
    return chineseDays;
}
//时间 转成字符串，如果date为空返回当前时间戳
+ (NSString *)stringFromDate:(NSDate *)date withFormatter:(NSString*)formatter
{
    NSString *destDateString = nil;
    if (date == nil) {
        NSDate *time_str = [NSDate new];
        destDateString =[NSString stringWithFormat:@"%ld",(long)[time_str timeIntervalSince1970]];
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if (formatter != nil) {
            [dateFormatter setDateFormat:formatter];
        }
        destDateString = [dateFormatter stringFromDate:date];
        [dateFormatter release];
    }
	return destDateString;
}
+ (NSString *)stringFromInterval:(NSTimeInterval)doubleValue withFormatter:(NSString*)formatter
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    if (formatter) {
        [dateFormatter setDateFormat:formatter];
    }else{
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:doubleValue];
    return  [dateFormatter stringFromDate:confromTimesp];
}
//时间转换成NSDateComponents
+(NSDateComponents *)getDateComponentsWithDate:(NSDate*)date
{
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *localeComp = [localeCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    [localeCalendar release];
    return localeComp;
}
//string to date
+(NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:string];
    [dateFormatter release];
    return destDate;
}
//string to date
+(NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!format) {
        format = @"yyyy-MM-dd hh:mm:ss";
    }
    [dateFormatter setDateFormat:format];
    NSDate *destDate= [dateFormatter dateFromString:string];
    [dateFormatter release];
    return destDate;
}
//时间戳转换成字符串
+(NSString *)timeStampFromString:(NSString *)string
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string integerValue]];
    return [Manager stringFromDate:confromTimesp withFormatter:@"yyyy-MM-dd hh:mm:ss"];
}
//
+(NSString*)getChineseCalendarWithDate:(NSString *)solarDate{
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int wCurYear,wCurMonth,wCurDay;
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[Manager dateFromString:solarDate]];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            nBit = nBit % 2;
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    NSString *lunarDate = [NSString stringWithFormat:@"%i-%i-%i",wCurYear,wCurMonth,wCurDay];
    return lunarDate;
}
////////
+(NSString*)getGregorianCalendarWithDate:(NSString *)date//阴历转阳历
{
    return [calendarDic valueForKey:date];
}
+(NSString*)getGregorianRYCalendarWithDate:(NSString *)date//闰月 阴历转阳历
{
    return [calendarryDic valueForKey:date];
}
+(NSString*)getRunyueWithYear:(NSString *)year//根据年得到闰年
{
    return [calendarryearDic valueForKey:year];
}
+(NSString*)getTianGanWithString:(NSString*)string runyue:(NSInteger)runyue
{
    
    NSArray* arr = [string componentsSeparatedByString:@"-"];
    if ([arr count] != 3) {
        return string;
    }
    NSInteger year = [[arr objectAtIndex:0] integerValue];
    NSInteger month = [[arr objectAtIndex:1] integerValue];
    NSInteger day = [[arr objectAtIndex:2] integerValue];
    
    NSString *m_str = [chineseMonths objectAtIndex:month-1];
    NSString *d_str = [chineseDays objectAtIndex:day-1];
    if (runyue != 0) {
        m_str = [NSString stringWithFormat:@"闰%@",m_str];
    }
    return [NSString stringWithFormat:@"%i年%@%@",year, m_str,d_str];
}
+ (NSString*)getYMDWithString:(NSString*)string//将1985-11-17转成1985年11月17日
{
    string = [NSMutableString stringWithString:string];
    [string replaceCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    [string replaceCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    string = [string stringByAppendingString:@"日"];
    return string;
}
+ (NSString*)checkRUNNIANWithSDate:(NSString*)string//阳历检查是否是闰年
{
    NSDate* date = [Manager dateFromString:string];
    if (date == nil) {
        string = [NSMutableString stringWithString:string];
        [string replaceCharactersInRange:NSMakeRange(5, [string length]-5) withString:@"3-1"];
    }
    return string;
}
+ (NSString*)checkRUNYUEWithSDate:(NSString*)string//阴历检查是否是闰月
{
    NSArray* arr = [string componentsSeparatedByString:@"-"];
    if ([arr count] != 3) {
        return string;
    }
    NSInteger year = [[arr objectAtIndex:0] integerValue];
    NSInteger month = [[arr objectAtIndex:1] integerValue];
    NSInteger day = [[arr objectAtIndex:2] integerValue];
    if (day == 30) {
        if (![Manager getGregorianCalendarWithDate:string]) {
            //            if ([Manager getGregorianRYCalendarWithDate:string]) {
            if (month == 12) {
                year += 1;
                month = 1;
            }else {
                month += 1;
                day = 1;
            }
            return [NSString stringWithFormat:@"%i-%i-%i",year,month,day];
            //            }
        }
    }
    return string;
}
+ (NSString*)getShuxiangByYear:(NSInteger)year
{
    return [cShuXiang objectAtIndex:((year - 4) % 60) % 12];
}
+ (NSString*)getXingzuoByDate:(NSDate*)date
{
    if (date == nil) {
        return nil;
    }
    NSDateComponents* compon = [Manager getDateComponentsWithDate:date];
    NSInteger yeay = compon.year;
    
    NSData* date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-3-21",yeay]];
    NSData* date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-4-19",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"白羊座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-4-20",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-5-20",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"金牛座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-5-21",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-6-21",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"双子座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-6-22",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-7-22",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"巨蟹座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-7-23",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-8-22",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"狮子座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-8-23",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-9-22",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"处女座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-9-23",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-10-23",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"天秤座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-10-24",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-11-21",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"天蝎座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-11-22",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-12-21",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"射手座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-12-22",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-12-30",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"摩羯座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-1-1",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-1-19",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"摩羯座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-1-20",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-2-18",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"水瓶座";
    }
    date1 = [Manager dateFromString:[NSString stringWithFormat:@"%i-2-19",yeay]];
    date2 = [Manager dateFromString:[NSString stringWithFormat:@"%i-3-20",yeay]];
    if ([date timeIntervalSinceDate:date1]>=0 && [date timeIntervalSinceDate:date2]<=0) {
        return @"双鱼座 ";
    }
    return nil;
}
+ (NSArray*)arrayWithData:(NSData*)data
{
    Byte *testByte = (Byte *)[data bytes];
    NSArray* byteArr = [NSMutableArray array];
    for(int i=0;i<[data length];i++){
        NSNumber* b = [NSNumber numberWithInt:testByte[i]];
        [byteArr addObject:b];
    }
    return byteArr;
}
+ (NSData*)dataWithArray:(NSArray*)dataArr
{
    if (dataArr == nil) {
        return nil;
    }
    NSInteger count = [dataArr count];
    Byte byte[count];
    for(int i=0;i<count;i++){
        NSInteger bbb = [[dataArr objectAtIndex:i]integerValue];
        byte[i] = bbb;
    }
    return [NSData dataWithBytes:byte length:count];
}
+ (NSDictionary*)getBirthdayDicByDic:(NSDictionary*)dic
{
    NSArray* dayArr_ = [NSArray arrayWithObjects:@"当天",@"提前一天",@"提前两天",@"提前三天",@"提前四天",@"提前五天",@"提前六天",@"提前一周",@"提前一月", nil];
    
    NSDate* newDate_;
    NSInteger nowYear_;
    
    newDate_ = [[NSDate alloc]init];
    NSDateComponents *localeComp = [Manager getDateComponentsWithDate:newDate_];
    nowYear_  = localeComp.year;
    
    NSString* str = [Manager stringFromDate:newDate_ withFormatter:nil];
    newDate_ =  [Manager dateFromString:str];
    [newDate_ retain];
    
    NSString* gbirthday_;
    NSString* cbirthday_;
    NSString* nextGBirthday_;
    NSString* nextCBirthday_;
    NSString* date_;
    
    NSString* birthdayKey_;
    
    
    NSString* numberLabel_;//距离阳历还有
    NSString* number_;//还有n天过生日
    NSInteger nianling_ = -1;//4岁
    NSString* shuxiang_;//属相
    NSString* xingzuo_;//星座
    
    NSString* birthdayTypeTmp_;//阳历,阴历

    
    BOOL isshowyear = [[dic valueForKey:@"isshowyear"] boolValue];
    NSInteger birthdayYeay = 0;
    NSTimeInterval interval;
    if (isshowyear) {
        NSMutableString* gbirthday = [dic valueForKey:@"gbirthday"];
        NSMutableString* cbirthday = [dic valueForKey:@"cbirthday"];
        birthdayTypeTmp_ = [dic valueForKey:@"birthdayType"];
        
        
        NSInteger year = [[cbirthday substringToIndex:4]integerValue];
        shuxiang_ = [[Manager getShuxiangByYear:year] retain];
        
        gbirthday_ = [gbirthday retain];
        cbirthday_ = [[Manager getTianGanWithString:cbirthday runyue:[[dic valueForKey:@"runyue"] integerValue]] retain];
        
        NSDate* dateTmp = nil;
        if ([birthdayTypeTmp_ isEqualToString:@"0"]) {//公
            numberLabel_ = [[NSString alloc]initWithString:@"阳历生日"];
            gbirthday = [NSMutableString stringWithString:gbirthday];
            
            
            birthdayYeay = [[gbirthday substringToIndex:4]integerValue];
            nianling_ = nowYear_ - birthdayYeay;
            
            [gbirthday replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",nowYear_]];
            cbirthday = [Manager getChineseCalendarWithDate:gbirthday];
            
            interval = [[Manager dateFromString:gbirthday] timeIntervalSinceDate:newDate_];
            if (interval < 0) {
                [gbirthday replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",nowYear_+1]];
                gbirthday = [Manager checkRUNNIANWithSDate:gbirthday];
                cbirthday = [Manager getChineseCalendarWithDate:gbirthday];
                nianling_ = nowYear_ - birthdayYeay + 1;
            }else if (interval == 0) {
                nianling_ += 1;
            }
        }else{//农
            //            NSDateComponents *localeComp = [Manager getDateComponentsWithDate:newDate_];
            //            nowYear_  = localeComp.year;
            NSString* str = [Manager stringFromDate:newDate_ withFormatter:nil];
            str = [Manager getChineseCalendarWithDate:str];
            str = [NSMutableString stringWithString:str];
            nowYear_ =[[str substringToIndex:4] integerValue];
            
            numberLabel_ = [[NSString alloc]initWithString:@"农历生日"];
            cbirthday = [NSMutableString stringWithString:cbirthday];
            
            NSInteger year = [[cbirthday substringToIndex:4]integerValue];
            shuxiang_ = [[Manager getShuxiangByYear:year] retain];
            
            birthdayYeay = [[cbirthday substringToIndex:4]integerValue];
            nianling_ = nowYear_ - birthdayYeay;
            
            [cbirthday replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",nowYear_]];
            cbirthday = [Manager checkRUNYUEWithSDate:cbirthday];
            cbirthday = [NSMutableString stringWithString:cbirthday];
            gbirthday = [Manager getGregorianCalendarWithDate:cbirthday];
            
            interval = [[Manager dateFromString:gbirthday] timeIntervalSinceDate:newDate_];
            if (interval < 0) {
                NSString* str = [NSString stringWithFormat:@"%i",nowYear_+1];
                [cbirthday replaceCharactersInRange:NSMakeRange(0, 4) withString:str];
                cbirthday = [Manager checkRUNYUEWithSDate:cbirthday];
                cbirthday = [NSMutableString stringWithString:cbirthday];
                gbirthday = [Manager getGregorianCalendarWithDate:cbirthday];
                nianling_ = nowYear_ - birthdayYeay + 1;
            }else if (interval == 0) {
                nianling_ += 1;
            }
        }
        
        nianling_ -= 1;
        dateTmp = [Manager dateFromString:gbirthday];
        
        interval = [dateTmp timeIntervalSinceDate:newDate_];
        
        nextGBirthday_ = [gbirthday retain];
        nextCBirthday_ = [[Manager getTianGanWithString:cbirthday runyue:0] retain];
        
        xingzuo_ = [[Manager getXingzuoByDate:[Manager dateFromString:nextGBirthday_]]retain];
    }else {
        shuxiang_ = [[NSString alloc]initWithString:@"未知"];
        
        gbirthday_ = [dic valueForKey:@"gbirthday"];
        gbirthday_ = [gbirthday_ stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
        gbirthday_ = [gbirthday_ stringByAppendingString:@"日"];
        [gbirthday_ retain];
        
        NSString* gbirthday = [NSString stringWithFormat:@"%i-%@",nowYear_,[dic valueForKey:@"gbirthday"]];
        NSString* cbirthday = [NSString stringWithFormat:@"%i-%@",nowYear_,[dic valueForKey:@"cbirthday"]];
        
        birthdayTypeTmp_ = [dic valueForKey:@"birthdayType"];
        
        NSDate* dateTmp = nil;
        if ([birthdayTypeTmp_ isEqualToString:@"0"]) {//公
            
            numberLabel_ = [[NSString alloc]initWithString:@"阳历生日"];
            cbirthday_ = @"未知";
            
            gbirthday = [NSMutableString stringWithString:gbirthday];
            dateTmp = [Manager dateFromString:gbirthday];
            
            interval = [dateTmp timeIntervalSinceDate:newDate_];
            if (interval < 0) {
                [gbirthday replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",nowYear_+1]];
                gbirthday = [Manager checkRUNNIANWithSDate:gbirthday];
            }
            cbirthday = [Manager getChineseCalendarWithDate:gbirthday];
            nextGBirthday_ = [gbirthday retain];
            nextCBirthday_ = [[Manager getTianGanWithString:cbirthday runyue:0] retain];
            
            xingzuo_ = [[Manager getXingzuoByDate:[Manager dateFromString:nextGBirthday_]]retain];
            
        }else{//农
            numberLabel_ = [[NSString alloc]initWithString:@"农历生日"];
            gbirthday_ = @"未知";
            
            cbirthday = [NSMutableString stringWithString:cbirthday];
            cbirthday = [Manager checkRUNNIANWithSDate:cbirthday];
            gbirthday = [Manager getGregorianCalendarWithDate:cbirthday];
            interval = [[Manager dateFromString:gbirthday] timeIntervalSinceDate:newDate_];
            if (interval < 0) {
                [cbirthday replaceCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",nowYear_+1]];
                cbirthday = [Manager checkRUNYUEWithSDate:cbirthday];
                cbirthday = [NSMutableString stringWithString:cbirthday];
                gbirthday = [Manager getGregorianCalendarWithDate:cbirthday];
            }
            cbirthday_ = [dic valueForKey:@"cbirthday"];
            NSArray* arr = [cbirthday_ componentsSeparatedByString:@"-"];
            NSArray* chineseMonths = [Manager getChineseMonths];
            NSArray* chineseDays = [Manager getChineseDays];
            NSInteger index = [[arr objectAtIndex:0] integerValue] - 1;
            NSString *m_str = [chineseMonths objectAtIndex:index];
            index = [[arr objectAtIndex:1] integerValue] - 1;
            NSString *d_str = [chineseDays objectAtIndex:index];
            cbirthday_ = [NSString stringWithFormat:@"%@%@",m_str,d_str];
            [cbirthday_ retain];
            
            nextGBirthday_ = [gbirthday retain];
            nextCBirthday_ = [[Manager getTianGanWithString:cbirthday runyue:0] retain];
            xingzuo_ = @"未知";
        }
        dateTmp = [Manager dateFromString:gbirthday];
        interval = [dateTmp timeIntervalSinceDate:newDate_];
    }
    [birthdayTypeTmp_ retain];
    
    float interval02bySec=((float)interval);
    float dayNumber = interval02bySec/24/60/60;
    
    [dic setValue:xingzuo_ forKey:@"xingzuo"];
    [dic setValue:nextCBirthday_ forKey:@"nextCBirthday"];
    [dic setValue:nextGBirthday_ forKey:@"nextGBirthday"];
    [dic setValue:cbirthday_ forKey:@"cbirthday"];
    [dic setValue:gbirthday_ forKey:@"gbirthday"];
    [dic setValue:[NSNumber numberWithInt:nianling_] forKey:@"age"];
    [dic setValue:shuxiang_ forKey:@"shuxiang"];
    [dic setValue:[NSNumber numberWithFloat:dayNumber] forKey:@"number"];
    return dic;
}
//弹窗
+(void)showAlertView:(NSString*)title withMessage:(NSString*)message withID:(id)delegate withTag:(NSInteger)tag
{
    UIAlertView *alertView = nil;
    if (delegate == nil) {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:delegate
                                     cancelButtonTitle:@"确定"
                                     otherButtonTitles:nil];
    }
    else{
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:delegate
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"确定",nil];
        alertView.tag = tag;
    }
    [alertView show];
    [alertView release];
}
@end