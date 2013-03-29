//
//  RootViewController.h
//  Birthday
//
//  Created by XPFirst on 13-3-28.
//  Copyright (c) 2013年 XPFirst. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIDateSelect;
@interface RootViewController : UIViewController
{
    UIButton               *_birthdayBtn;//选择生日
    UISegmentedControl     *_birthdayType;//阳历,阴历选择
    UIDateSelect           *_pickViewNav;//日期选择控件
    
    //生日信息
    NSInteger             _nowYear;//当前年份
    NSInteger             _gyear;//公历年份
    NSInteger             _gmonth;//公历月份
    NSInteger             _gday;//公历的天
    NSInteger             _gdayNumber;//公历天的数量
    
    NSInteger             _cyear;//农历年份
    NSInteger             _cmonth;//农历月份
    NSInteger             _cmonthNumber;//农历的天
    NSInteger             _runyueMonthOrder;//闰月所有的月份
    NSInteger             _cday;//农历的天
    NSInteger             _cdayNumber;//农历天的数量
    
    NSInteger             _dayIndex;//选择天
    NSInteger             _hour;//选择的小时
    
    NSString              *_birthdayKey;//要修改的生日的key
    NSArray               *_chineseMonths;//农历的月份数量
    NSArray               *_chineseDays;//农历所在月的天数
    long                  _key;//保存头像用的key
    Boolean               _isShowYear;//是否显示年
    
    //显示生日信息
    UILabel*              _gBirthdayLab;//阳历生日
    UILabel*              _cBirthdayLab;//阴历生日
    UILabel*              _nextGBirthdayLab;//下一个阳历生日
    UILabel*              _nextCBirthdayLab;//下一个阴历生日
    UILabel*              _xingzuoLab;//星座
    UILabel*              _shuxiangLab;//阴历生日
    UILabel*              _ageLab;//年龄
}
@end
