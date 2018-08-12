//
//  YGStadiumDetailHeadView.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallPhoneBlock)(void);

@interface YGStadiumDetailHeadView : UIView

@property (nonatomic,copy)   CallPhoneBlock callPhone;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel     *labelName;
@property (nonatomic,copy)   NSString    *phone;
@property (nonatomic,copy)   NSString    *address;
@property (nonatomic,copy)   NSString    *workTime;
@end
