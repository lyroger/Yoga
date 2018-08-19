//
//  YGStadiumModel.h
//  YoGa
//
//  Created by 罗琰 on 2018/8/6.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGStadiumModel : BaseModel

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phoneNo;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) double longitude;
@property (nonatomic,assign) double latitude;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,assign) NSInteger stadiumId;
@property (nonatomic,copy) NSString *businessHours;

+ (void)getStadiumListsByName:(NSString*)searchName
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
                       target:(id)target
                      success:(NetResponseBlock)success;

+ (void)getStadiumInfoById:(NSInteger)stadiumId
                    target:(id)target
                   success:(NetResponseBlock)success;
@end
