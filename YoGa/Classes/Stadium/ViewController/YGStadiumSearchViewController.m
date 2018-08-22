//
//  YGStadiumSearchViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/19.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGStadiumSearchViewController.h"
#import "YGStadiumCell.h"
#import "YGStadiumModel.h"
#import "YGStadiumDetailVC.h"

@interface YGStadiumSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UIView *topContentView;
}

@property (nonatomic,strong) UITableView *tableViewList;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,copy) NSString *searchValue;

@end

@implementation YGStadiumSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    [self textFieldReturn];
    // Do any additional setup after loading the view.
}

- (NSMutableArray*)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}


- (void)loadSubView
{
    topContentView = [UIView new];
    topContentView.backgroundColor = UIColorHex(0xFFFFFF);
    self.view.backgroundColor = topContentView.backgroundColor;
    [self.view addSubview:topContentView];
    
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.placeholder = @"请输入场馆名称";
    searchBar.height = 46;
    searchBar.delegate = self;
    searchBar.barTintColor = topContentView.backgroundColor;
    UITextField * searchField = [searchBar valueForKey:@"_searchField"];
    [searchField setFont:[UIFont systemFontOfSize:14]];
    //去掉上下两条黑线
    searchBar.layer.borderWidth = 1;
    searchBar.layer.borderColor = [searchBar.barTintColor CGColor];
    UIView *searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = UIColorHex(0xEEEEEE);
    [topContentView addSubview:searchBar];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorHex(0x666666) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [topContentView addSubview:cancelButton];
    
    [topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
        if (@available(iOS 11.0,*)) {
            if (iPhoneX) {
                make.top.mas_equalTo(self.view.safeAreaInsets.top).mas_offset(32);
            } else {
                make.top.mas_equalTo(self.view.top);
            }
        } else {
            make.top.mas_equalTo(self.view.top);
        }
    }];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(32);
        make.right.mas_equalTo(-45);
    }];
    
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(searchBar.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 32));
    }];
    
    [searchBar becomeFirstResponder];
    
    self.tableViewList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableViewList.dataSource = self;
    self.tableViewList.delegate = self;
    self.tableViewList.backgroundColor = UIColorHex(0xffffff);
    [self.tableViewList registerClass:[YGStadiumCell class] forCellReuseIdentifier:@"YGStadiumCell"];
    [self.view addSubview:self.tableViewList];
    
    @weakify(self);
    self.tableViewList.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshData];
    }];
    self.pageIndex = 0;
    
    [self.tableViewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topContentView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)cancelSearch
{
    [self.view endEditing:YES];
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)refreshData
{
    self.pageIndex = 0;
    [self loadStadiumsData];
}

- (void)loadStadiumsData
{
    [YGStadiumModel getStadiumListsByName:self.searchValue pageSize:20 pageIndex:self.pageIndex target:self success:^(StatusModel *data) {
        [self.tableViewList.mj_header endRefreshing];
        [self.tableViewList.mj_footer endRefreshing];
        if (data.code == 0) {
            NSArray *stadiums = [YGStadiumModel mj_objectArrayWithKeyValuesArray:[data.originalData objectForKey:@"rows"]];
            if (self.pageIndex == 0) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:stadiums];
            BOOL hasMoreData = true;
            if ([[data.originalData objectForKey:@"total"] integerValue] == self.dataList.count) {
                [self.tableViewList.mj_footer endRefreshingWithNoMoreData];
                hasMoreData = false;
            } else {
                self.pageIndex ++;
            }
            if (self.pageIndex == 1 && hasMoreData) {
                self.tableViewList.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadStadiumsData)];
            }
            [self.tableViewList reloadData];
        } else {
            
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGStadiumModel *model = self.dataList[indexPath.row];
    YGStadiumDetailVC *vc = [[YGStadiumDetailVC alloc] init];
    vc.stadiumInfo = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGStadiumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGStadiumCell"];
    [cell model:self.dataList[indexPath.row]];
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchtext = %@",searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length) {
        [searchBar resignFirstResponder];
        self.searchValue = searchBar.text;
        [self loadStadiumsData];
    } else {
        [HUDManager alertWithTitle:@"请输入搜索关键词"];
    }
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
