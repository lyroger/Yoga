//
//  YGFeedBackViewController.m
//  YoGa
//
//  Created by 罗琰 on 2018/8/12.
//  Copyright © 2018年 QinYoga. All rights reserved.
//

#import "YGFeedBackViewController.h"
#import "UITextView+PlaceHolder.h"

@interface YGFeedBackViewController ()
{
    UITextView  *_contentTextView;
    UILabel *_tipLabel;
}

@end

@interface YGFeedBackViewController ()

@end

@implementation YGFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"意见反馈";
    self.view.backgroundColor = UIColorHex(0xffffff);
    //加载视图
    [self  initView];
    
    [self textFieldReturn];
    // Do any additional setup after loading the view.
}

- (void)initView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(15, 15+64, kScreenWidth-30, 175)];
    backgroundView.backgroundColor = UIColorHex(0xffffff);
    [self.view addSubview:backgroundView];
    
    backgroundView.layer.borderWidth = 0.5;
    backgroundView.layer.borderColor = UIColorHex(0x333333).CGColor;
    backgroundView.layer.cornerRadius = 5;
    
    //输入内容
    _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, backgroundView.frame.size.width-20, backgroundView.frame.size.height-35)];
    _contentTextView.backgroundColor = UIColorHex(0xffffff);
    //    _contentTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _contentTextView.backgroundColor = UIColorHex(0xffffff);
    _contentTextView.font = [UIFont systemFontOfSize:14];
    _contentTextView.textColor = UIColorHex(0x333333);
    [backgroundView addSubview:_contentTextView];
    
    [_contentTextView addPlaceHolder:@"反馈相关意见..."];
    _contentTextView.placeHolderTextView.textContainerInset = _contentTextView.textContainerInset;
    
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _contentTextView.bottom+5,  backgroundView.width - 10, 12)];
    _tipLabel.textColor = UIColorHex(0x999999);
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.font = [UIFont systemFontOfSize:12];
    [backgroundView addSubview:_tipLabel];
    _tipLabel.text = @"0/200";
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(15, backgroundView.bottom+15, kScreenWidth-30, 44);
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    confirmBtn.backgroundColor = UIColorHex(0x121212);
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFiledEditChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    
    if ([_contentTextView isFirstResponder]) {
        
    }
}

#pragma mark - actions
- (void)submitAction
{
    [self.view endEditing:YES];
    
}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text]) {
        return NO;
    }
    return YES;
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
