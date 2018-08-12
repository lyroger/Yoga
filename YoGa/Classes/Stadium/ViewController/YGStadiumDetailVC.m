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
        _headView.callPhone = ^{
            NSLog(@"拨打电话");
        };
    }
    return _headView;
}

- (YGSelectedDateView*)selectDateView
{
    if (!_selectDateView) {
        _selectDateView = [[YGSelectedDateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        __weak typeof(self) weakSelf = self;
        _selectDateView.selectedDateBlock = ^(NSInteger index) {
            NSLog(@"index= %zd",index);
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableDetailView reloadData];
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

- (void)loadSubView{
    self.tableDetailView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableDetailView.dataSource = self;
    self.tableDetailView.delegate = self;
    self.tableDetailView.tableHeaderView = self.headView;
    [self.tableDetailView registerClass:[YGCourseCell class] forCellReuseIdentifier:@"YGCourseCell"];
    [self.view addSubview:self.tableDetailView];
    
    [self.tableDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    self.headView.labelName.text = @"紫音瑜伽馆";
    self.headView.phone = @"18688889999";
    self.headView.address = @"宝安中心 <1km内";
    self.headView.workTime = @"营业时间 9:00~21:00";
    
    for (int i = 0; i<10; i++) {
        YGCourseModel *model = [YGCourseModel new];
        model.name = @"户外瑜伽";
        model.teacher = @"请老师";
        model.time = @"9:00~10:00";
        model.count = 50;
        model.courseID = i;
        [self.courseList addObject:model];
    }
    NSArray *dates = @[@"07-01",@"07-02",@"07-03",@"07-04",@"07-05",@"07-06",@"07-07"];
    NSArray *weeks = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    NSMutableArray *dateWeeks = [NSMutableArray new];
    for (int i = 0; i<7; i++) {
        YGSelectDateModel *model = [YGSelectDateModel new];
        if ([dates[i] isEqualToString:@"07-02"]) {
            model.selected = YES;
        }
        model.date = dates[i];
        model.week = weeks[i];
        [dateWeeks addObject:model];
    }
    [self.selectDateView setData:dateWeeks];
    [self.tableDetailView reloadData];
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
    cell.orderCourse = ^(YGCourseModel *model) {
        NSLog(@"order %zd",model.courseID);
    };
    cell.cancelCourse = ^(YGCourseModel *model) {
        NSLog(@"cancel %zd",model.courseID);
    };
    return cell;
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
