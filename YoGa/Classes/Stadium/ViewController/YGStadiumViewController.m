//
//  YGStadiumViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumViewController.h"
#import "YGStadiumCell.h"
#import "YGStadiumModel.h"

@interface YGStadiumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableViewList;
@property (nonatomic,strong) NSMutableArray *dataList;
@end

@implementation YGStadiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"场馆";
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (NSMutableArray*)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (void)loadSubView{
    self.tableViewList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableViewList.dataSource = self;
    self.tableViewList.delegate = self;
    [self.tableViewList registerClass:[YGStadiumCell class] forCellReuseIdentifier:@"YGStadiumCell"];
    [self.view addSubview:self.tableViewList];

    [self.tableViewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    for (NSInteger i = 0; i< 15; i++) {
        YGStadiumModel *model = [[YGStadiumModel alloc] init];
        model.name = @"紫英瑜伽馆";
        model.address = @"南山区大冲商务中心";
        model.distance = @"南山 < 500m";
        model.imageURL = @"";
        [self.dataList addObject:model];
    }
    [self.tableViewList reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGStadiumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGStadiumCell"];
    [cell model:self.dataList[indexPath.row]];
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
