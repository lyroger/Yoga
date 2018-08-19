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

@interface YGMyCourseViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableDetailView;
@property (nonatomic,strong) NSMutableArray *courseList;
@property (nonatomic,strong) UIButton *btnItem1;
@property (nonatomic,strong) UIButton *btnItem2;
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
    self.btnItem1.frame = CGRectMake(0, 0, 64, 30);
    self.btnItem1.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnItem1 setTitle:@"已约" forState:UIControlStateNormal];
    [self.btnItem1 setBackgroundColor:UIColorHex(0x121212)];
    [self.btnItem1 setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    [self.btnItem1 addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnItem1.tag = 100;
    [segmentView addSubview:self.btnItem1];
    
    self.btnItem2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnItem2.frame = CGRectMake(64, 0, 64, 30);
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
    } else {
        [self.btnItem2 setBackgroundColor:UIColorHex(0x121212)];
        [self.btnItem2 setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        
        [self.btnItem1 setBackgroundColor:UIColorHex(0xffffff)];
        [self.btnItem1 setTitleColor:UIColorHex(0x121212) forState:UIControlStateNormal];
    }
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
    [self.tableDetailView registerClass:[YGCourseCell class] forCellReuseIdentifier:@"YGCourseCell"];
    [self.view addSubview:self.tableDetailView];
    
    [self.tableDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    for (int i = 0; i<10; i++) {
        YGCourseModel *model = [YGCourseModel new];
        model.name = @"户外瑜伽";
        model.teacher = @"请老师";
        model.time = @"9:00~10:00";
        model.count = 50;
        model.courseId = i;
        [self.courseList addObject:model];
    }
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
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGCourseCell"];
    YGCourseModel *model = [self.courseList objectAtIndex:indexPath.row];
    [cell model:model];
    cell.orderCourse = ^(YGCourseModel *model) {
        NSLog(@"order %zd",model.courseId);
    };
    cell.cancelCourse = ^(YGCourseModel *model) {
        NSLog(@"cancel %zd",model.courseId);
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
