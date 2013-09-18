//
//  DAYCYSubViewController.m
//  OCRProject
//
//  Created by 于 川頁 on 13-9-13.
//  Copyright (c) 2013年 于 川頁. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAYCYSubViewController.h"
#import "DAYCYViewController.h"
#import "Tesseract.h"

@interface DAYCYSubViewController ()

@end

@implementation DAYCYSubViewController
@synthesize UIImageBig,UIImageSmall,UITextViewResults,OCRString, UILabelLanguage, UIBarButtonStartOCR,ResultString,UILabelProgressing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 * -viewDidLoad
 * [Function]Load時に親ビューから画像データとセグメントデータをもらう
 * [Data]2013.09.17
 * [Author]Daycy
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UITextViewResults setHidden:YES];
    [UIImageSmall setHidden:YES];
    [UILabelProgressing setHidden:YES];

    int index = [self.navigationController.viewControllers count];
    DAYCYViewController *parentViewCon = (DAYCYViewController *)[self.navigationController.viewControllers objectAtIndex:(index - 2)];
    
    UIImageSmall.image = UIImageBig.image = parentViewCon.takenImage;
    UIImageBig.frame = CGRectMake(0,0,UIImageBig.image.size.width, UIImageBig.image.size.height);
    UIImageSmall.frame = CGRectMake(0,0,UIImageSmall.image.size.width, UIImageSmall.image.size.height);
	
    switch (parentViewCon.nSegIndex) {
        case 1:
            OCRString = OCRStringJpn;
            ResultString = RESULTStringJpn;
            UILabelLanguage.text = LABELStringJpn;
            break;
        case 2:
            OCRString = OCRStringChs;
            ResultString = RESULTStringChs;
            UILabelLanguage.text = LABELStringChs;
            break;
        case 0:
        default:
            OCRString = OCRStringEng;
            ResultString = RESULTStringEng;
            UILabelLanguage.text = LABELStringEng;
            break;
    }
}

/*
 * -actionStartOCR
 * [Function]OCRを開始する処理
 * [Data]2013.09.18
 * [Author]Daycy
 */
- (IBAction)actionStartOCR:(id)sender {
    self.navigationItem.hidesBackButton = YES; //将Cancel BarButton暂时隐藏
    self.navigationItem.rightBarButtonItem.enabled = NO; //将StartOCR BarButton设置为无效
    [UILabelProgressing setHidden:NO];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    CABasicAnimation *rotation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.duration = 1.5;
    rotation.repeatCount = 3;
    rotation.fromValue = [NSNumber numberWithFloat:0.0];
    rotation.toValue = [NSNumber numberWithFloat:(M_PI / 180) * 360];
    [UILabelProgressing.layer addAnimation:rotation forKey:@"rotateAnimation"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Tesseract *tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:OCRString];
        [tesseract setImage:self.UIImageBig.image];
        [tesseract recognize];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.hidesBackButton = NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [UIImageBig setHidden:YES];
            [UIImageSmall setHidden:NO];
            [UITextViewResults setHidden:NO];
            [UIView commitAnimations];
            [UILabelProgressing setHidden:YES];
            UITextViewResults.text = [NSString stringWithFormat:ResultString,[tesseract recognizedText]];
            [tesseract clear];
        });
    });
    UIImageSmall.userInteractionEnabled = YES;
#define MYBirthDayTag 0x0716
    UIImageSmall.tag = MYBirthDayTag; /*生日～呵呵*/
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * -touchesBegan
 * [Function]MYBirthDayTagのオブジェクトがタップされたら、イメージ拡大効果
 * [Data]2013.09.18
 * [Author]Daycy
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (MYBirthDayTag == ((UITouch *)[[event allTouches] anyObject]).view.tag) {
        [UIImageBig setHidden:NO];
    }
}

/*
 * -touchesEnded
 * [Function]MYBirthDayTagのオブジェクトがタップされたら、イメージ拡大効果
 * [Data]2013.09.18
 * [Author]Daycy
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (MYBirthDayTag == ((UITouch *)[[event allTouches] anyObject]).view.tag) {
        [UIImageBig setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    UIImageBig.image = UIImageSmall.image = nil;
}
@end
