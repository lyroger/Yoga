//
//  YGStadiumViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/1.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumViewController.h"
#import "YGStadiumCell.h"

@interface YGStadiumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableViewList;
@end

@implementation YGStadiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"场馆";
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView{
    self.tableViewList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableViewList.dataSource = self;
    self.tableViewList.delegate = self;
    [self.tableViewList registerClass:[YGStadiumCell class] forCellReuseIdentifier:@"YGStadiumCell"];
    [self.view addSubview:self.tableViewList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGStadiumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGStadiumCell"];
    
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
