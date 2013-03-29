//
//  UIDateSelect.m
//  Haonz
//
//  Created by gaojindan on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIDateSelect.h"
#import "Manager.h"

@implementation UIDateSelect
@synthesize delegate;
@synthesize gyear = gyear_;
@synthesize gmonth = gmonth_;
@synthesize gday = gday_;
@synthesize cyear = cyear_;
@synthesize cmonth = cmonth_;
@synthesize cday = cday_;
@synthesize runyueMonthOrder = runyueMonthOrder_;
@synthesize isShowYear = isShowYear_;
- (id)init
{
    self = [super init];
    if (self) {
        isShowYear_ = TRUE;
        chineseMonths=[[NSArray alloc]initWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",   
                       @"九月", @"十月", @"冬月", @"腊月", nil];  
                
        chineseDays=[[NSArray alloc]initWithObjects: 
                     @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",   
                     @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",  
                     @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];  
        
        pickerView_ = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        pickerView_.delegate = self;
        pickerView_.dataSource = self;
        pickerView_.tag = 1;
        pickerView_.showsSelectionIndicator = YES;
        
        UIViewController* pickViewController = [[UIViewController alloc]init];
        
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(quit)];
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
        segmentedControl_ = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"保留年份",@"隐藏年份", nil]];
        segmentedControl_.frame = CGRectMake(10, 5, 180, 30);
        segmentedControl_.selectedSegmentIndex = 0;
        [segmentedControl_ addTarget:self action:@selector(showYear:) forControlEvents:UIControlEventValueChanged];
        
        pickViewController.navigationItem.leftBarButtonItem = leftItem;
        pickViewController.navigationItem.rightBarButtonItem = rightItem;
        pickViewController.navigationItem.titleView = segmentedControl_;
        [leftItem release];
        [rightItem release];
        
        [pickViewController.view addSubview: pickerView_]; 

        [self pushViewController:pickViewController animated:YES];
        
        [pickViewController release];
        
        CGRect rect;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5) {
            rect = CGRectMake(0, 159, 320, 350);
        }else{
            rect = CGRectMake(0, kScreenHeight-270, 320, 350);
        }
        self.view.frame = rect;
        
        
        
        NSDate *new = [NSDate new];
        NSDateComponents *localeComp = [Manager getDateComponentsWithDate:new];
        nowYear_ = gyear_ = localeComp.year;
        gmonth_ = localeComp.month;
        gday_ = localeComp.day;
        
        
        localeComp = [Manager getDateComponentsWithDate:new];
        cyear_ = localeComp.year;
        cmonth_ = localeComp.month;
        cday_ = localeComp.day;
        
        gdayNumber_ = 31;
        cdayNumber_ = 30;
        cmonthNumber_ = 12;
        birthdayType_ = 0;
        
    }
    return self;
}
- (void)showYear:(UISegmentedControl*)segmented
{
    NSInteger index = segmented.selectedSegmentIndex;
    if (index == 0) {
        isShowYear_ = TRUE;
    }else if (index == 1) {
        isShowYear_ = FALSE;
    }
    [pickerView_ reloadAllComponents];
    
    gyear_ = cyear_ = nowYear_;
    cmonthNumber_ = 12;
    cdayNumber_ = 30;
    gdayNumber_ = 31;
    
    [self changeType:birthdayType_];
    [self changeGDaynumber];

}
-(void)changeType:(NSInteger)type//0阳历，1阴历
{
    birthdayType_ = type;
    pickerView_.tag = type + 1;
    if (isShowYear_) {
        segmentedControl_.selectedSegmentIndex = 0;
        if(type == 0){
            [pickerView_ selectRow:gyear_ - 1921 inComponent:0 animated:YES];
            [pickerView_ selectRow:gmonth_-1 inComponent:1 animated:YES];
            [pickerView_ selectRow:gday_-1 inComponent:2 animated:YES];
            [self changeGDaynumber];
            [pickerView_ reloadComponent:2];
        }else {
            [self changeCMonthnumber];
            [pickerView_ selectRow:cyear_ - 1921 inComponent:0 animated:YES];
            [pickerView_ selectRow:cmonth_-1 inComponent:1 animated:YES];
            [pickerView_ selectRow:cday_-1 inComponent:2 animated:YES];
            [self performSelector:@selector(changeCDaynumber) withObject:nil];
        }
    }else {
        segmentedControl_.selectedSegmentIndex = 1;
        if(type == 0){
            [pickerView_ selectRow:gmonth_-1 inComponent:0 animated:YES];
            [pickerView_ selectRow:gday_-1 inComponent:1 animated:YES];
            [self changeGDaynumber];
            [pickerView_ reloadComponent:1];
        }else {
            [self changeCMonthnumber];
            [pickerView_ selectRow:cmonth_-1 inComponent:0 animated:YES];
            [pickerView_ selectRow:cday_-1 inComponent:1 animated:YES];
        }
    }
}
- (void)changeGDaynumber
{
    if (gmonth_ == 1 || gmonth_ == 3 || gmonth_ == 5 || gmonth_ == 7 || gmonth_ == 8 || gmonth_ == 10 || gmonth_ == 12) {
        gdayNumber_ = 31;
    }else if (gmonth_ == 4 || gmonth_ == 6 || gmonth_ == 9 || gmonth_ == 11) {
        gdayNumber_ = 30;
    }else if(gmonth_ == 2){
        if(isShowYear_){
            if (gyear_%4 == 0) {
                gdayNumber_ = 29;
            }else {
                gdayNumber_ = 28;
            }
        }else {
            gdayNumber_ = 29;
        }
    }
}
- (void)changeCMonthnumber
{
    NSString* str = [Manager getRunyueWithYear:[NSString stringWithFormat:@"%i",cyear_]];
    if (str == nil) {
        cmonthNumber_ = 12;
    }else {
        cmonthNumber_ = 13;
    }
    runyueMonthOrder_ = [str integerValue];
    [pickerView_ reloadComponent:1];
}
- (void)changeCDaynumber
{
    NSString* str = [NSString stringWithFormat:@"%i-%i-%i",cyear_,cmonth_,30];
    str = [Manager getGregorianCalendarWithDate:str];
    if (str == nil) {
        cdayNumber_ = 29;
    }else {
        cdayNumber_ = 30;
    }
    if (isShowYear_) {
        [pickerView_ reloadComponent:2];
    }else {
        [pickerView_ reloadComponent:1];
    }
}
#pragma UIPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isShowYear_) {
        if (pickerView.tag == 1) {
            if (component == 0) {
                gyear_ = 1921+row;
                if (gmonth_ == 2) {
                    [self changeGDaynumber];
                    [pickerView reloadComponent:2];
                }
            }else if (component == 1) {
                gmonth_ = row+1;
                [self changeGDaynumber];
                [pickerView reloadComponent:2];
            }else if (component == 2) {
                gday_ = row+1;
            }
        }else if(pickerView.tag == 2) {
            if (component == 0) {
                cyear_ = 1921+row;
                [self performSelector:@selector(changeCMonthnumber) withObject:nil];
            }else if (component == 1) {
                cmonth_ = row+1;
                [self performSelector:@selector(changeCDaynumber) withObject:nil];
            }else if (component == 2) {
                cday_ = row+1;
            }
        }
    }else {
        if (pickerView.tag == 1) {
            if (component == 0) {
                gmonth_ = row+1;
                [self changeGDaynumber];
                [pickerView reloadComponent:1];
                if (gday_ == 31) {
                    gday_ = 30;
                }
            }else if (component == 1) {
                gday_ = row+1;
            }
        }else if(pickerView.tag == 2) {
            if (component == 0) {
                cmonth_ = row+1;
            }else if (component == 1) {
                cday_ = row+1;
            }
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (isShowYear_) {
        return 3;
    }else {
        return 2;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isShowYear_) {
        if (pickerView.tag == 1) {
            if (component == 0) {
                return nowYear_ - 1921+1;
            }else if (component == 1) {
                return 12;
            }else if (component == 2) {
                return gdayNumber_;
            }
        }else if (pickerView.tag == 2){
            if (component == 0) {
                return nowYear_ - 1921+1;
            }else if (component == 1) {
                return cmonthNumber_;
            }else if (component == 2) {
                return cdayNumber_;
            }
        }
    }else {
        if (pickerView.tag == 1) {
            if (component == 0) {
                return 12;
            }else if (component == 1) {
                return gdayNumber_;
            }
        }else if (pickerView.tag == 2){
            if (component == 0) {
                return cmonthNumber_;
            }else if (component == 1) {
                return cdayNumber_;
            }
        }
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (isShowYear_) {
        if (pickerView.tag == 1) {
            row += 1;
            if (component == 0) {
                return [NSString stringWithFormat:@"%i年",1920+row];
            }else if (component == 1) {
                return [NSString stringWithFormat:@"%i月",row];
            }else if (component == 2) {
                return [NSString stringWithFormat:@"%i日",row];
            }
        }else if (pickerView.tag == 2){
            if (component == 0) {
                return [NSString stringWithFormat:@"%i年",1921+row];
            }else if (component == 1) {
                if (row == 12) {
                    return [NSString stringWithFormat:@"闰%@",[chineseMonths objectAtIndex:runyueMonthOrder_-1]];
                }else {
                    return [chineseMonths objectAtIndex:row];
                }
            }else if (component == 2) {
                return [chineseDays objectAtIndex:row];
            }
        }
    }else {
        if (pickerView.tag == 1) {
            row += 1;
            if (component == 0) {
                return [NSString stringWithFormat:@"%i月",row];
            }else if (component == 1) {
                return [NSString stringWithFormat:@"%i日",row];
            }
        }else if (pickerView.tag == 2){
            if (component == 0) {
                if (row == 12) {
                    return [NSString stringWithFormat:@"闰%@",[chineseMonths objectAtIndex:runyueMonthOrder_-1]];
                }else {
                    return [chineseMonths objectAtIndex:row];
                }
            }else if (component == 1) {
                return [chineseDays objectAtIndex:row];
            }
        }
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (isShowYear_) {
        return 107;
    }else {
        return 80;
    }
}
- (void)quit
{
    if(delegate && [delegate respondsToSelector:@selector(dateSelectQuit:)])
    {
        [delegate dateSelectQuit:self];  
    }
}
- (void)ok
{
    if(delegate && [delegate respondsToSelector:@selector(dateSelectOK:)])
    {
        [delegate dateSelectOK:self];  
    } 
}
- (void)dealloc
{
    if (chineseDays != nil) {
        [chineseDays release];
        chineseDays = nil;
    }
    if (chineseMonths != nil) {
        [chineseMonths release];
        chineseMonths = nil;
    }
    if (pickerView_ != nil) {
        pickerView_.delegate = nil;
        pickerView_.dataSource = nil;
        [pickerView_ release];
        pickerView_ = nil;
    }
    if (segmentedControl_ != nil) {
        [segmentedControl_ release];
        segmentedControl_ = nil;
    }
    [super dealloc];
}

@end
