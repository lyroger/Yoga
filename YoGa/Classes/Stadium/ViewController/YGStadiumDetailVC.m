//
//  YGStadiumDetailVC.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumDetailVC.h"
#import "YGStadiumDetailHeadView.h"
#import "YGCourseCell.h"
#import "YGCourseModel.h"
#import "YGSelectedDateView.h"
#import "YGSelectDateModel.h"

@interface YGStadiumDetailVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableDetailView;
@property (nonatomic,strong) YGStadiumDetailHeadView *headView;
@property (nonatomic,strong) YGSelectedDateView *selectDateView;
@property (nonatomic,strong) NSMutableArray *courseList;
@property (nonatomic,strong) NSMutableArray *weekList;
@property (nonatomic,strong) YGSelectDateModel *currentDateModel;
@end

@implementation YGStadiumDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self loadSubView];
    // Do any additional setup after loading the view.
}
- (YGStadiumDetailHeadView*)headView
{
    if (!_headView) {
        _headView = [[YGStadiumDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 118)];
        @weakify(self);
        _headView.callPhone = ^{
            @strongify(self);
            NSLog(@"拨打电话");
            if (self.stadiumInfo.phoneNo.length) {
                NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.stadiumInfo.phoneNo];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:num]]];
                [self.view addSubview:callWebview];
            }
        };
    }
    return _headView;
}

- (YGSelectedDateView*)selectDateView
{
    if (!_selectDateView) {
        _selectDateView = [[YGSelectedDateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        @weakify(self);
        _selectDateView.selectedDateBlock = ^(NSInteger index) {
            NSLog(@"index= %zd",index);
            @strongify(self)
            self.currentDateModel = [self.weekList objectAtIndex:index];
            [self loadCoursesData];
        };
    }
    return _selectDateView;
}

- (NSMutableArray *)courseList
{
    if (!_courseList) {
        _courseList = [[NSMutableArray alloc] init];
    }
    return _courseList;
}

- (NSMutableArray*)weekList
{
    if (!_weekList) {
        _weekList = [[NSMutableArray alloc] init];
    }
    return _weekList;
}

- (void)loadSubView{
    self.tableDetailView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableDetailView.dataSource = self;
    self.tableDetailView.delegate = self;
    self.tableDetailView.tableHeaderView = self.headView;
    self.tableDetailView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableDetailView registerClass:[YGCourseCell class] forCellReuseIdentifier:@"YGCourseCell"];
    [self.view addSubview:self.tableDetailView];
    
    [self.tableDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    [self loadDetailInfo];
}

- (void)loadDetailInfo
{
    self.headView.labelName.text = self.stadiumInfo.name;
    self.headView.phone = self.stadiumInfo.phoneNo;
    self.headView.address = [NSString stringWithFormat:@"%@ %@",self.stadiumInfo.address,self.stadiumInfo.distance];// @"宝安中心 <1km内";
    self.headView.workTime = [NSString stringWithFormat:@"营业时间 %@",self.stadiumInfo.businessHours];
    [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.stadiumInfo.imageURL] placeholderImage:[UIImage imageNamed:@"list_pic"]];
    [self getWeekDateInfo];
    self.currentDateModel = [self.weekList objectAtIndex:0];
    [self loadCoursesData];
}

- (void)loadCoursesData
{
    [YGCourseModel getCoursesInfoById:[NSString stringWithFormat:@"%zd",self.stadiumInfo.stadiumId] date:self.currentDateModel.dateValue target:self success:^(StatusModel *data) {
        if (data.code == 0) {
            [self.courseList removeAllObjects];
            NSArray *courses = [YGCourseModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"rows"]];
            [self.courseList addObjectsFromArray:courses];
            [self.tableDetailView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.selectDateView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGCourseCell"];
    YGCourseModel *model = [self.courseList objectAtIndex:indexPath.row];
    [cell model:model];
    @weakify(self)
    cell.orderCourse = ^(YGCourseModel *model) {
        @strongify(self)
        NSLog(@"order %zd",model.courseId);
        [YGCourseModel orderCoursesById:[NSString stringWithFormat:@"%zd",model.classId]
                                 userId:[YGUserInfo shareUserInfo].userId
                                 target:self success:^(StatusModel *data) {
                                     if (data.code == 0) {
                                         model.orderFlag = 1;
                                         [self.tableDetailView reloadData];
                                     }
            
        }];
    };
    cell.cancelCourse = ^(YGCourseModel *model) {
        @strongify(self)
        NSLog(@"cancel %zd",model.courseId);
        [YGCourseModel cancelCoursesById:[NSString stringWithFormat:@"%zd",model.classId] target:self success:^(StatusModel *data) {
            if (data.code == 0) {
                model.orderFlag = 0;
                [self.tableDetailView reloadData];
            }
        }];
    };
    return cell;
}

- (YGSelectDateModel*)getSelectDateModelOffsetIndex:(NSInteger)index
{
    NSDate *today = [NSDate date];
    
    NSDate *selectedDate = [today dateByAddingTimeInterval:index*24*60*60];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit ;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:selectedDate];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger week = [dateComponent weekday];
    
    YGSelectDateModel *model = [YGSelectDateModel new];
    
    NSString *monthStr = [NSString stringWithFormat:@"%zd",month];
    if (month<10) {
        monthStr = [NSString stringWithFormat:@"0%zd",month];
    }
    NSString *dayStr = [NSString stringWithFormat:@"%zd",day];
    if (day<10) {
        dayStr = [NSString stringWithFormat:@"0%zd",day];
    }
    
    model.date = [NSString stringWithFormat:@"%@-%@",monthStr,dayStr];
    model.dateValue = [NSString stringWithFormat:@"%zd%@%@",year,monthStr,dayStr];
    NSArray *weeks = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    model.week = weeks[week-1];
    return model;
}

- (void)getWeekDateInfo
{
    NSMutableArray *dateWeeks = [NSMutableArray new];
    for (int i = 0; i<7; i++) {
        YGSelectDateModel *model = [self getSelectDateModelOffsetIndex:i];
        model.selected = i==0?YES:NO;
        [dateWeeks addObject:model];
    }
    [self.weekList addObjectsFromArray:dateWeeks];
    [self.selectDateView setData:dateWeeks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
