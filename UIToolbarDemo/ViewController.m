//
//  ViewController.m
//  UIToolbarDemo
//
//  Created by Cloudox on 2016/11/22.
//  Copyright © 2016年 Cloudox. All rights reserved.
//

#import "ViewController.h"
#import "IDAddressPickerView.h"

//设备的宽高
#define SCREENWIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT      [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITextFieldDelegate, IDAddressPickerViewDataSource>

@property (nonatomic, strong) UITextField *keyboardText;
@property (nonatomic, strong) UITextField *pickerText;

@property (nonatomic, strong) IDAddressPickerView *addressPickerView;// 省市区选择器
@property (nonatomic, strong) UIToolbar *toolBar;// 工具栏

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 点击空白收起键盘
    UITapGestureRecognizer *tapBlack =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapBlack.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapBlack];
    
    // 背景视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    // 键盘输入文字
    UILabel *keyboardLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, 90, 17)];
    keyboardLabel.text = @"键盘输入：";
    keyboardLabel.textAlignment = NSTextAlignmentLeft;
    keyboardLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:keyboardLabel];
    
    // 键盘输入框
    self.keyboardText = [[UITextField alloc] initWithFrame:CGRectMake(keyboardLabel.frame.origin.x + keyboardLabel.frame.size.width + 10, 16, SCREENWIDTH - 122 - 12, 17)];
    self.keyboardText.borderStyle = UITextBorderStyleNone;
    self.keyboardText.placeholder = @"请输入";
    self.keyboardText.clearButtonMode = UITextFieldViewModeWhileEditing;// 清除全部按钮
    self.keyboardText.font = [UIFont systemFontOfSize:17];
    self.keyboardText.delegate = self;
    [bgView addSubview:self.keyboardText];
    
    // 分割线
    UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(12, 49.5, SCREENWIDTH - 24, 1)];
    cutline.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:cutline];
    
    // 选取器文字
    UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 66, 90, 17)];
    pickerLabel.text = @"选取器：";
    pickerLabel.textAlignment = NSTextAlignmentLeft;
    pickerLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:pickerLabel];
    
    // 选取器输入框
    self.pickerText = [[UITextField alloc] initWithFrame:CGRectMake(pickerLabel.frame.origin.x + pickerLabel.frame.size.width + 10, 66, SCREENWIDTH - 122 - 12, 17)];
    self.pickerText.borderStyle = UITextBorderStyleNone;
    self.pickerText.placeholder = @"请输入点击选择";
    self.pickerText.inputAccessoryView = self.toolBar;
    self.pickerText.inputView = self.addressPickerView;
    self.pickerText.clearButtonMode = UITextFieldViewModeWhileEditing;// 清除全部按钮
    self.pickerText.font = [UIFont systemFontOfSize:17];
    self.pickerText.delegate = self;
    [bgView addSubview:self.pickerText];
}

//隐藏键盘
-(void)dismissKeyBoard{
    [self.keyboardText resignFirstResponder];
    [self.pickerText resignFirstResponder];
}

- (IDAddressPickerView *)addressPickerView {
    if (_addressPickerView == nil) {
        _addressPickerView = [[IDAddressPickerView alloc] init];
        _addressPickerView.dataSource = self;
    }
    return _addressPickerView;
}

// 工具栏按钮
- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarCanelClick)];
        [barItems addObject:cancelBtn];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarDoneClick)];
        [barItems addObject:doneBtn];
        
        [_toolBar setItems:barItems animated:YES];
    }
    return _toolBar;
}

-(void)toolBarCanelClick{
    [self dismissKeyBoard];
}

-(void)toolBarDoneClick{
    [self dismissKeyBoard];
    
    NSLog(@"%@", self.addressPickerView.selectedAddress);
    self.pickerText.text = [NSString stringWithFormat:@"%@%@%@", self.addressPickerView.selectedAddress[@"Province"], self.addressPickerView.selectedAddress[@"CityKey"], self.addressPickerView.selectedAddress[@"AreaKey"]];
}

#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (![textField isEqual:self.pickerText]) {// 避免与选取器的工具栏起冲突，只在键盘输入框时添加
        //在键盘上添加toolbar工具条  点击工具条中的按钮回收键盘
        UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 22, 22)];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateHighlighted];
        [doneButton addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
        NSArray *buttonsArray = [NSArray arrayWithObjects:doneButtonItem,nil];
        //关键的代码，不写的话不会在键盘上面显示工具条
        [textField setInputAccessoryView:topView];
        [topView setItems:buttonsArray];
    }
}

#pragma mark - IDAddressPickerViewDataSource
- (NSArray *)addressArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    NSArray *addressInfo = [NSArray arrayWithContentsOfFile:path];
    return addressInfo;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
