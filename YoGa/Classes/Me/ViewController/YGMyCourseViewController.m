//
//  YGMyCourseViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGMyCourseViewController.h"
#import "YGCourseCell.h"
#import "YGCourseModel.h"
#import "YGCourseModel.h"

@interface YGMyCourseViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableDetailView;
@property (nonatomic,strong) NSMutableArray *courseList;
@property (nonatomic,strong) UIButton *btnItem1;
@property (nonatomic,strong) UIButton *btnItem2;
@property (nonatomic,assign) NSInteger viewType;
@property (nonatomic,assign) NSInteger pageIndex;
@end

@implementation YGMyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [self loadTitleView];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (UIView*)loadTitleView
{
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    segmentView.layer.borderWidth = 1;
    segmentView.layer.borderColor = UIColorHex(0x121212).CGColor;
    segmentView.layer.cornerRadius = 15;
    segmentView.layer.masksToBounds = YES;
    
    self.btnItem1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnItem1.frame = CGRectMake(0, 0, 65, 30);
    self.btnItem1.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnItem1 setTitle:@"已约" forState:UIControlStateNormal];
    [self.btnItem1 setBackgroundColor:UIColorHex(0x121212)];
    [self.btnItem1 setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [self.btnItem1 addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnItem1.tag = 100;
    [segmentView addSubview:self.btnItem1];
    
    self.btnItem2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnItem2.frame = CGRectMake(65, 0, 65, 30);
    self.btnItem2.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnItem2 setTitle:@"历史" forState:UIControlStateNormal];
    [self.btnItem2 setBackgroundColor:UIColorHex(0xffffff)];
    [self.btnItem2 setTitleColor:UIColorHex(0x121212) forState:UIControlStateNormal];
    [self.btnItem2 addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnItem2.tag = 101;
    [segmentView addSubview:self.btnItem2];
    
    return segmentView;
}

- (void)segmentClick:(UIButton*)button
{
    if (button.tag == 100) {
        [self.btnItem1 setBackgroundColor:UIColorHex(0x121212)];
        [self.btnItem1 setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        
        [self.btnItem2 setBackgroundColor:UIColorHex(0xffffff)];
        [self.btnItem2 setTitleColor:UIColorHex(0x121212) forState:UIControlStateNormal];

        self.viewType = 0;
    } else {
        [self.btnItem2 setBackgroundColor:UIColorHex(0x121212)];
        [self.btnItem2 setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        
        [self.btnItem1 setBackgroundColor:UIColorHex(0xffffff)];
        [self.btnItem1 setTitleColor:UIColorHex(0x121212) forState:UIControlStateNormal];

        self.viewType = 1;
    }

    [self refreshData];
}

- (void)refreshData
{
    self.pageIndex = 0;
    [self requestCourseData];
}

- (void)requestCourseData
{
    [YGCourseModel getOrderCoursesType:self.viewType pageSize:10 pageIndex:self.pageIndex*10 target:self success:^(StatusModel *data) {
        [self.tableDetailView.mj_header endRefreshing];
        [self.tableDetailView.mj_footer endRefreshing];

        if (data.code == 0) {
            NSArray *stadiums = [YGCourseModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"rows"]];
            if (self.pageIndex == 0) {
                [self.courseList removeAllObjects];
            }
            [self.courseList addObjectsFromArray:stadiums];
            BOOL hasMoreData = true;
            if ([[data.originalData objectForKey:@"total"] integerValue] == self.courseList.count) {
                [self.tableDetailView.mj_footer endRefreshingWithNoMoreData];
                hasMoreData = false;
            } else {
                self.pageIndex ++;
            }
            if (self.pageIndex == 1 && hasMoreData) {
                self.tableDetailView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestCourseData)];
            }
            [self.tableDetailView reloadData];
        }
    }];
}

- (NSMutableArray *)courseList
{
    if (!_courseList) {
        _courseList = [[NSMutableArray alloc] init];
    }
    return _courseList;
}

- (void)loadSubView{
    self.tableDetailView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableDetailView.dataSource = self;
    self.tableDetailView.delegate = self;
    self.tableDetailView.backgroundColor = self.view.backgroundColor;
    [self.tableDetailView registerClass:[YGCourseCell class] forCellReuseIdentifier:@"YGCourseCell"];
    [self.view addSubview:self.tableDetailView];
    @weakify(self);
    self.tableDetailView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshData];
    }];
    [self refreshData];
    
    [self.tableDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [self.tableDetailView reloadData];
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

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGCourseCell"];
    YGCourseModel *model = [self.courseList objectAtIndex:indexPath.row];
    [cell model:model isSign:self.viewType+1];
    @weakify(self)
    cell.signCourse = ^(YGCourseModel *model) {
        NSLog(@"sign %zd",model.classId);
        @strongify(self)
        [YGCourseModel signCoursesById:[NSString stringWithFormat:@"%zd",model.classId] target:self success:^(StatusModel *data) {
            @strongify(self)
            if (data.code == 0) {
                model.signFlag = 1;
                [self.tableDetailView reloadData];
            }
        }];
    };
    cell.cancelCourse = ^(YGCourseModel *model) {
        NSLog(@"cancel %zd",model.classId);
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [YGCourseModel cancelCoursesById:[NSString stringWithFormat:@"%zd",model.classId] target:self success:^(StatusModel *data) {
                    if (data.code == 0) {
                        model.orderFlag = 0;
                        [self.tableDetailView reloadData];
                    }
                }];
            }
        } title:nil message:@"确定要取消预约吗？" cancelButtonName:@"否" otherButtonTitles:@"是", nil];

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
