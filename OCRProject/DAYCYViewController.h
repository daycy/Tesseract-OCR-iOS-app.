//
//  DAYCYViewController.h
//  TextRec
//
//  Created by 于 川頁 on 13-9-8.
//  Copyright (c) 2013年 于 川頁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAYCYSubViewController.h"



@interface DAYCYViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImage *takenImage;
    NSInteger nSegIndex;
}
@property UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *takenImage;
@property NSInteger nSegIndex;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segLanguages;

@end
