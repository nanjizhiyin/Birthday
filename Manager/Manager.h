//
//  Manager.h
//  Haonz
//
//  Created by gaojindan on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define SYSTEMVERSION [[UIDevice currentDevice] systemVersion]//系统版本，如4.2.1

#define SYSTEMNAME [[UIDevice currentDevice] systemName]//系统名称，如iPhone OS

#define SYSTEMMODEL [[UIDevice currentDevice] model]//The model of the device，如iPhone或者iPod touch

#define UNIQUEIDENTIFIER [[UIDevice currentDevice] uniqueIdentifier]//设备的惟一标识号，deviceID

#define LOCALIZEDMODEL [[UIDevice currentDevice] localizedModel]//The model of the device as a localized string

#define  INFODICTIONARY [[NSBundle mainBundle] infoDictionary]//info.plist





//#define DOCUMENTS  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]
#define CACHES  [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"]
#define FILEMANAGER [NSFileManager defaultManager]
#define USERDEFAULTS  [NSUserDefaults stand

#define DIR_ImageCache              [CACHES stringByAppendingPathComponent:@"ImageCache"]//贺卡文件夹

#define DIR_BIRTHDAY_GREETINGCARDS            [CACHES stringByAppendingPathComponent:@"greetingcards"]//贺卡文件夹
#define DIR_BIRTHDAY_LOGO           [CACHES stringByAppendingPathComponent:@"logo"]//头像文件夹

#define PATH_SET                    [CACHES stringByAppendingPathComponent:@"set.plist"]
#define GUANFANG_SET                    [CACHES stringByAppendingPathComponent:@"guanfang.plist"]
#define PATH_CALENDAR               [CACHES stringByAppendingPathComponent:@"calendar.plist"]//万年历
#define PATH_CALENDARRY             [CACHES stringByAppendingPathComponent:@"calendarry.plist"]//万年历闰月只列出闰月的年份
#define PATH_CALENDARRYEAR          [CACHES stringByAppendingPathComponent:@"calendarryear.plist"]//万年历 年--闰月份

#define PATH_GREETINGCARDS          [CACHES stringByAppendingPathComponent:@"greetingcards.plist"]//贺卡的名字保存这里
#define GREETINGCARDS_DATE           @"greetingcards_date"//最新贺卡的更新时间
#define GREETINGCARDS_REFRESHDATE    @"greetingcards_refreshdate"//贺卡点击量刷新时间,每天刷一次就好
#define SMS_DATE                     @"sms_date"//最新祝福短信的更新时间
#define SMS_REFRESHDATE              @"sms_refreshdate"//祝福短信点击量刷新时间,每天刷一次就好
#define PATH_GREETINGSMS             [CACHES stringByAppendingPathComponent:@"greetingSMS.plist"]//祝福短信的名字保存这里
#define PATH_SOUND                   [CACHES stringByAppendingPathComponent:@"sound.wav"]//录音的地址
#define PATH_BIRTHDAYS               [CACHES stringByAppendingPathComponent:@"birthdays.plist"]//生日信息
#define PATH_BIRTHDAYSLOGO           [CACHES stringByAppendingPathComponent:@"birthdaysLogo.plist"]//logo

#define USER_ID                      @"user_id"//用户id
#define USER_NAME                    @"user_name"//账号
#define USER_PASSWORD                @"user_password"//密码
#define USER_ISREMEBER               @"isRemember"//是否记住密码
#define USER_ISFIRST                 @"isFirst"//用户第一次登录
#define LOAD_ISFIRST                 @"load_isfirst" //程序安装后第一次运行

#define DEVICETOKEN                  @"deviceToken"//push专用

#define SET_ISOPENSOUND              @"isOpenSound" //是否打开声音


#define ISUPDEVICETOKEN              @"isupdeviceToken" //已经上传了手机标识


#define NUMBERSPERIOD                @"0123456789"
#define ALPHA                        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@#$%&*.0123456789"

#define notificationCenterIsLogin         @"notificationCenterIsLogin"//登录、退出
#define notificationCenterCheckLogin      @"notificationCenterCheckLogin"//后台登录验证
#define notificationCenterBirthdayChange  @"notificationCenterBirthdayChange"//生日信息有变化如添加，删除，修改
#define notificationCenterHelpHide        @"notificationCenterHelpHide"//隐帮助

#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width

//声音路径和名字
#define       kSoundItemPath  [[NSBundle mainBundle] URLForResource:@"item" withExtension: @"wav"]
#define       kSoundErrorPath  [[NSBundle mainBundle] URLForResource:@"error" withExtension: @"wav"]

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class ASIFormDataRequest,ViewManager,AVAudioPlayer;

@interface Manager : NSObject
{
    
}
+ (void)init;


+ (NSDateComponents *)getDateComponentsWithDate:(NSDate*)date;
//时间 转成字符串，如果date为空返回当前时间戳
+ (NSString *)stringFromDate:(NSDate *)date withFormatter:(NSString*)formatter;
//时间戳 转成字符串
+ (NSString *)stringFromInterval:(NSTimeInterval)doubleValue withFormatter:(NSString*)formatter;
//字符串转化成时间
+ (NSDate *)dateFromString:(NSString *)string;
//string to date
+(NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

//时间戳转换成字符串
+ (NSString *)timeStampFromString:(NSString *)string;
//获取中国月列表
+ (NSArray*)getChineseMonths;
//获取天列表
+ (NSArray*)getChineseDays;
//转换成中国日期
+ (NSString*)getChineseCalendarWithDate:(NSString *)date;
+ (NSString*)getGregorianCalendarWithDate:(NSString *)date;//阴历转成阳历时用到
+ (NSString*)getTianGanWithString:(NSString*)string  runyue:(NSInteger)runyue;//将1985-11-17转成1985年冬月十七
+ (NSString*)getYMDWithString:(NSString*)string;//将1985-11-17转成1985年11月17日
+ (NSString*)getRunyueWithYear:(NSString *)year;//根据年得到闰年
+ (NSString*)checkRUNNIANWithSDate:(NSString*)string;//阳历检查是否是闰年
+ (NSString*)checkRUNYUEWithSDate:(NSString*)string;//阴历检查是否是闰月
+ (UIImage *)scaleToSize:(UIImage *)sourceImage size:(CGSize)targetSize;

+ (NSString*)getShuxiangByYear:(NSInteger)year;//获取属相
+ (NSString*)getXingzuoByDate:(NSDate*)date;//获取星座
//data转化成字节
+ (NSArray*)arrayWithData:(NSData*)data;
//字节转化成data
+ (NSData*)dataWithArray:(NSArray*)dataArr;
+ (NSDictionary*)getBirthdayDicByDic:(NSDictionary*)dic;//计算生日信息

//弹窗
+ (void)showAlertView:(NSString*)title withMessage:(NSString*)message withID:(id)delegate withTag:(NSInteger)tag;
@end
