//
//  DAYCYSubViewController.h
//  OCRProject
//
//  Created by 于 川頁 on 13-9-13.
//  Copyright (c) 2013年 于 川頁. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OCRStringEng @"eng"
#define OCRStringJpn @"jpn"
#define OCRStringChs @"chi_sim"

#define LABELStringEng @"English Mode"
#define LABELStringJpn @"日本語モード"
#define LABELStringChs @"中文模式"

#define RESULTStringEng @"Recognized>>>:\n%@"
#define RESULTStringJpn @"識別結果>>>:\n%@"
#define RESULTStringChs @"识别结果>>>:\n%@"

@interface DAYCYSubViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *UIImageBig;
@property (strong, nonatomic) IBOutlet UITextView *UITextViewResults;
@property (strong, nonatomic) IBOutlet UIImageView *UIImageSmall;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *UIBarButtonStartOCR;
@property (strong, nonatomic) IBOutlet UILabel *UILabelLanguage;
@property (strong, nonatomic) NSString * OCRString;
@property (strong, nonatomic) NSString * ResultString;
@property (strong, nonatomic) IBOutlet UILabel *UILabelProgressing;

@end
