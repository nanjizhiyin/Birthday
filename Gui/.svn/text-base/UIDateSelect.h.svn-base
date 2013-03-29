//
//  UIDateSelect.h
//  Haonz
//
//  Created by gaojindan on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIDateSelectDelegate;

@interface UIDateSelect : UINavigationController<UIPickerViewDelegate>
{
    NSArray* chineseMonths; 
    NSArray* chineseDays;
    
    NSInteger birthdayType_;
    UIPickerView* pickerView_;
    
    NSInteger nowYear_;
    NSInteger gyear_;
    NSInteger gmonth_;
    NSInteger gday_;
    NSInteger gdayNumber_;
    
    NSInteger cyear_;
    NSInteger cmonth_;
    NSInteger cmonthNumber_;
    NSInteger runyueMonthOrder_;
    NSInteger cday_;
    NSInteger cdayNumber_;
    UISegmentedControl* segmentedControl_;
    BOOL isShowYear_;
}
@property(nonatomic,retain) id<UIDateSelectDelegate> delegate;
-(void)changeType:(NSInteger)type;//0阳历，1阴历
@property(nonatomic)NSInteger gyear;
@property(nonatomic)NSInteger gmonth;
@property(nonatomic)NSInteger gday;
@property(nonatomic)NSInteger cyear;
@property(nonatomic)NSInteger cmonth;
@property(nonatomic)NSInteger cday;
@property(nonatomic)NSInteger runyueMonthOrder;
@property(nonatomic)BOOL isShowYear;
@end
///////
@protocol UIDateSelectDelegate <NSObject>
@optional
- (void)dateSelectOK:(UIDateSelect *)dateSelect;
- (void)dateSelectQuit:(UIDateSelect *)dateSelect;
@end
