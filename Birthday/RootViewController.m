//
//  RootViewController.m
//  Birthday
//
//  Created by XPFirst on 13-3-28.
//  Copyright (c) 2013年 XPFirst. All rights reserved.
//

#import "RootViewController.h"
#import "Manager.h"
#import "UIDateSelect.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"生日转换";
    
    //初始化数据
    _isShowYear = YES;
    _chineseMonths=[[NSArray alloc]initWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                    @"九月", @"十月", @"冬月", @"腊月", nil];
    
    _chineseDays=[[NSArray alloc]initWithObjects:
                  @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                  @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                  @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSInteger x = 5;
    NSInteger y = 5;
    _birthdayType = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"阳历",@"阴历", nil]];
    _birthdayType.frame = CGRectMake(x, y, 100, 30);
    _birthdayType.selectedSegmentIndex = 0;
    [self.view addSubview:_birthdayType];
    
    _birthdayBtn = [[UIButton alloc]initWithFrame:CGRectMake(130, y, 180, 30)];
    _birthdayBtn.backgroundColor = [UIColor blackColor];
    [_birthdayBtn setTitle:@"请点我" forState:UIControlStateNormal];
    [_birthdayBtn addTarget:self action:@selector(selectBirthday) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_birthdayBtn];
    
    y += 30;
    _gBirthdayLab = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 320, 30)];
    [self.view addSubview:_gBirthdayLab];
    
    y += 30;
    _cBirthdayLab = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 320, 30)];
    [self.view addSubview:_cBirthdayLab];
    
    y += 30;
    _nextGBirthdayLab = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 320, 30)];
    [self.view addSubview:_nextGBirthdayLab];
    
    y += 30;
    _nextCBirthdayLab = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 320, 30)];
    [self.view addSubview:_nextCBirthdayLab];
    
    y += 30;
    _xingzuoLab = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 320, 30)];
    [self.view addSubview:_xingzuoLab];
    
    y += 30;
    _shuxiangLab = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 320, 30)];
    [self.view addSubview:_shuxiangLab];
    
    y += 30;
    _ageLab = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 320, 30)];
    [self.view addSubview:_ageLab];
}
#pragma UIDateSelect
//确定选择此日期
- (void)dateSelectOK:(UIDateSelect *)dateSelect
{
    _gyear = _pickViewNav.gyear;
    _gmonth = _pickViewNav.gmonth;
    _gday = _pickViewNav.gday;
    _cyear = _pickViewNav.cyear;
    _cmonth = _pickViewNav.cmonth;
    _cday = _pickViewNav.cday;
    _runyueMonthOrder = _pickViewNav.runyueMonthOrder;
    _isShowYear = _pickViewNav.isShowYear;
    
    [self pickerQuit];
    [self setTime];
}
//日期选择控件释放
- (void)pickerQuit
{
    if (_pickViewNav != nil) {
        [_pickViewNav.view removeFromSuperview];
        [_pickViewNav release];
        _pickViewNav = nil;
    }
}
//关闭选择界面
- (void)dateSelectQuit:(UIDateSelect *)dateSelect
{
    [self pickerQuit];
    //[self setTime];
}
//设置显示内容
- (void)setTime
{
    if (_isShowYear) {
        if (_birthdayType.selectedSegmentIndex == 0) {
            [_birthdayBtn setTitle:[NSString stringWithFormat:@"%i-%i-%i",_gyear,_gmonth,_gday] forState:UIControlStateNormal];
        }else {
            //[_birthday setTitle:[NSString stringWithFormat:@"%i-%i-%i",_cyear,_cmonth,_cday] forState:UIControlStateNormal];
            NSString* month;
            if (_cmonth == 13) {
                month = [NSString stringWithFormat:@"闰%@",[_chineseMonths objectAtIndex:_runyueMonthOrder - 1]];
            }else {
                month = [_chineseMonths objectAtIndex:_cmonth-1];
            }
            [_birthdayBtn setTitle:[NSString stringWithFormat:@"%i年%@%@",_cyear,month,[_chineseDays objectAtIndex:_cday-1]] forState:UIControlStateNormal];
        }
    }else {
        if (_birthdayType.selectedSegmentIndex == 0) {
            [_birthdayBtn setTitle:[NSString stringWithFormat:@"%i-%i",_gmonth,_gday] forState:UIControlStateNormal];
        }else {
            NSString* month;
            if (_cmonth == 13) {
                month = [NSString stringWithFormat:@"闰%@",[_chineseMonths objectAtIndex:_runyueMonthOrder - 1]];
            }else {
                month = [_chineseMonths objectAtIndex:_cmonth-1];
            }
            [_birthdayBtn setTitle:[NSString stringWithFormat:@"%@%@",month,[_chineseDays objectAtIndex:_cday-1]] forState:UIControlStateNormal];
        }
    }
    
    [self saveToDic];//保存到字典结构中
}
//保存信息生成对应的阳,阴历日期
- (void)saveToDic
{
    NSMutableDictionary* btdDic = [NSMutableDictionary dictionary];
    [btdDic setValue:[NSNumber numberWithInt:0] forKey:@"runyue"];
    NSInteger typeTmp = _birthdayType.selectedSegmentIndex;
    NSString* keyTmp;
    NSDate* dateTmp;
    [btdDic setValue:[NSNumber numberWithBool:_isShowYear] forKey:@"isshowyear"];
    if (_isShowYear) {//显示年
        if(typeTmp == 0){
            keyTmp = [NSString stringWithFormat:@"%i-%i-%i",_gyear,_gmonth,_gday];
            
            dateTmp = [Manager dateFromString:keyTmp];//将2011-5-8转成2011-05-08
            NSTimeInterval inter = [dateTmp timeIntervalSinceNow];
            if (inter > 0) {
                [Manager showAlertView:@"生日日期不能大于当前日期" withMessage:nil withID:nil withTag:0];
                return;
            }
            
            keyTmp = [Manager stringFromDate:dateTmp withFormatter:nil];
            
            [btdDic setValue:keyTmp forKey:@"gbirthday"];
            keyTmp = [Manager getChineseCalendarWithDate:keyTmp];
            [btdDic setValue:keyTmp forKey:@"cbirthday"];
        }else {//阴
            if (_cmonth == 13) {
                keyTmp = [NSString stringWithFormat:@"%i-%i-%i",_cyear,_runyueMonthOrder,_cday];
                [btdDic setValue:[NSNumber numberWithInt:_runyueMonthOrder] forKey:@"runyue"];
            }else{
                keyTmp = [NSString stringWithFormat:@"%i-%i-%i",_cyear,_cmonth,_cday];
            }
            [btdDic setValue:keyTmp forKey:@"cbirthday"];
            
            if (_cmonth == 13) {
                keyTmp = [Manager getGregorianRYCalendarWithDate:keyTmp];
            }else {
                keyTmp = [Manager getGregorianCalendarWithDate:keyTmp];
            }
            dateTmp = [Manager dateFromString:keyTmp];//将2011-5-8转成2011-05-08
            keyTmp = [Manager stringFromDate:dateTmp withFormatter:nil];
            [btdDic setValue:keyTmp forKey:@"gbirthday"];
            
            NSTimeInterval inter = [dateTmp timeIntervalSinceNow];
            if (inter > 0) {
                [Manager showAlertView:@"生日日期不能大于当前日期" withMessage:nil withID:nil withTag:0];
                return;
            }
        }
    }else {
        if(typeTmp == 0){
            keyTmp = [NSString stringWithFormat:@"%i-%i",_gmonth,_gday];
            [btdDic setValue:keyTmp forKey:@"gbirthday"];
            [btdDic setValue:@"" forKey:@"cbirthday"];
        }else {
            keyTmp = [NSString stringWithFormat:@"%i-%i",_cmonth,_cday];
            [btdDic setValue:keyTmp forKey:@"cbirthday"];
            [btdDic setValue:@"" forKey:@"gbirthday"];
        }
    }
    [btdDic setValue:[NSString stringWithFormat:@"%i",typeTmp] forKey:@"birthdayType"];
    NSLog(@"dic = %@",btdDic);
    [self showBirthdayInfo:btdDic];
}
//显示计算后的信息
- (void)showBirthdayInfo:(NSDictionary *)dic
{
    dic = [Manager getBirthdayDicByDic:dic];
    NSLog(@"dic2 = %@",dic);
    
    //显示生日信息
    _gBirthdayLab.text = [NSString stringWithFormat:@"阳历生日:%@",[dic valueForKey:@"gbirthday"]];
    _cBirthdayLab.text = [NSString stringWithFormat:@"阴历生日:%@",[dic valueForKey:@"cbirthday"]];
    _nextGBirthdayLab.text = [NSString stringWithFormat:@"下一个阳历生日:%@",[dic valueForKey:@"nextGBirthday"]];
    _nextCBirthdayLab.text = [NSString stringWithFormat:@"下一个阴历生日%@",[dic valueForKey:@"nextCBirthday"]];
    _xingzuoLab.text = [NSString stringWithFormat:@"星座:%@",[dic valueForKey:@"xingzuo"]];
    _shuxiangLab.text = [NSString stringWithFormat:@"属相:%@",[dic valueForKey:@"shuxiang"]];
    
    if (_isShowYear) {
        _ageLab.text = [NSString stringWithFormat:@"年龄:%@周岁",[dic valueForKey:@"age"]];
    }else {
        _ageLab.text = @"年龄:未知";
    }
}
//打开生日选择界面
- (void)selectBirthday
{
    if (_pickViewNav != nil) {
        [_pickViewNav.view removeFromSuperview];
        [_pickViewNav release];
        _pickViewNav = nil;
    }
    _pickViewNav = [[UIDateSelect alloc]init];
    _pickViewNav.delegate = self;
    
    [_pickViewNav changeType:_birthdayType.selectedSegmentIndex];
    [self.view addSubview:_pickViewNav.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
    [self dealloc];
    if (_birthdayBtn) {
        [_birthdayBtn release];
        _birthdayBtn = nil;
    }
    if (_birthdayType) {
        [_birthdayType release];
        _birthdayType = nil;
    }
    if (_pickViewNav) {
        [_pickViewNav release];
        _pickViewNav = nil;
    }
    if (_birthdayKey) {
        [_birthdayKey release];
        _birthdayKey = nil;
    }
    if (_chineseMonths) {
        [_chineseMonths release];
        _chineseMonths = nil;
    }
    if (_chineseDays) {
        [_chineseDays release];
        _chineseDays = nil;
    }
    if (_gBirthdayLab) {
        [_gBirthdayLab release];
        _gBirthdayLab = nil;
    }
    if (_cBirthdayLab) {
        [_cBirthdayLab release];
        _cBirthdayLab = nil;
    }
    if (_nextGBirthdayLab) {
        [_nextGBirthdayLab release];
        _nextGBirthdayLab = nil;
    }
    if (_nextCBirthdayLab) {
        [_nextCBirthdayLab release];
        _nextCBirthdayLab = nil;
    }
    if (_xingzuoLab) {
        [_xingzuoLab release];
        _xingzuoLab = nil;
    }
    if (_shuxiangLab) {
        [_shuxiangLab release];
        _shuxiangLab = nil;
    }
    if (_shuxiangLab) {
        [_shuxiangLab release];
        _shuxiangLab = nil;
    }
    if (_ageLab) {
        [_ageLab release];
        _ageLab = nil;
    }
}
@end
