//
//  DAYCYViewController.m
//  TextRec
//
//  Created by 于 川頁 on 13-9-8.
//  Copyright (c) 2013年 于 川頁. All rights reserved.
//

#import "DAYCYViewController.h"


@interface DAYCYViewController ()
@end

@implementation DAYCYViewController
@synthesize nSegIndex, segLanguages, takenImage, imagePicker;

/*
 * -viewDidLoad
 * [Function]SegmentIndex的初始值未必是English,每一次ViewDidLoad都初始化nSegIndex
 * [Data]2013.09.17
 * [Author]Daycy
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    nSegIndex = segLanguages.selectedSegmentIndex;	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 * -selectedLanguage
 * [Function]选择要识别的语言(1.English,2.日本語,3.中文).
 * [Data]2013.09.12
 * [Author]Daycy
 */
- (IBAction)selectedLanguage:(id)sender {
    nSegIndex = segLanguages.selectedSegmentIndex;
}

/*
 * -buttonCemeraPushed
 * [Function]相机启动按钮被按下.
 * [Data]2013.09.13
 * [Author]Daycy
 */
- (IBAction)buttonCemeraPushed:(id)sender forEvent:(UIEvent *)event {
    //imageView.image = nil;
    [self startCameraControllerFromViewController: self usingDelegate: self];
}

/*
 * -buttonPhotoLibraryPushed
 * [Function]打开相册按钮被按下.
 * [Data]2013.09.13
 * [Author]Daycy
 */
- (IBAction)buttonPhotoLibraryPushed:(id)sender forEvent:(UIEvent *)event {
    [self openPhotoLibraryControllerFromViewController: self usingDelegate: self];
}

/*
 * -startCameraControllerFromViewController
 * [Function]相机启动.
 * [Data]2013.09.13
 * [Author]Daycy(prototype from tutorial)
 */
- (BOOL) startCameraControllerFromViewController: (UIViewController*)controller usingDelegate: (id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate {
    
    if (NO == ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        || (nil == delegate)
        || (nil == controller)) {
        /*如果相机不可用,Alert*/
        [[[UIAlertView alloc] initWithTitle:@"!Error!" message:@"Failed to start the camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    /*不允许使用Video*/
    // imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    /*设定为可以编辑*/
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = delegate;
    [controller presentViewController:imagePicker animated:YES completion:nil];
    return YES;
}

/*
 * -startPhotoLibraryControllerFromViewController
 * [Function]打开相册.
 * [Data]2013.09.13
 * [Author]Daycy(prototype by startCameraControllerFromViewController)
 */
- (BOOL) openPhotoLibraryControllerFromViewController: (UIViewController*)controller usingDelegate: (id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate {
    
    if ((NO == [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        || (nil == delegate)
        || (nil == controller)) {
         /*如果相册不可用,Alert*/
        [[[UIAlertView alloc] initWithTitle:@"!Error!" message:@"Failed to open the photo library." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    /*不允许使用Video*/
    //imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
     /*设定为可以编辑*/
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = delegate;
    [controller presentViewController:imagePicker animated:YES completion:nil];
    return YES;
}

/*
 * -imagePickerController
 * [Function]接受照片并将其显示
 * [Data]2013.09.17
 * [Author]Daycy
 */

/*09/17
 *View間のイメージ共有は親ビューから送るほうでうまくいかなかった。
 *子ビューから取得する方式で対応する。
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.takenImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];

    //画面を遷移させる。
    [self performSegueWithIdentifier:@"segueView2" sender:self];
    //カメラをリリース
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //   view2 = [DAYCYSubViewController new];
    //    [view2.UIImageBig setImage:self.takenImage];
    //[self.view addSubview:view2.view];
    
    //  [self.navigationController pushViewController:view2 animated:YES];
    
    /*
     UIStoryboard *sbSub = [UIStoryboard storyboardWithName:@"SubView" bundle:[NSBundle mainBundle]];
     DAYCYViewController2 *initalViewController = [sbSub instantiateInitialViewController];
     [self presentViewController:initalViewController animated:YES completion:nil];
     
     initalViewController.imageView.image = self.takenImage;
     */    /*
     [picker dismissViewControllerAnimated:YES completion:^{
     [self performSegueWithIdentifier:@"segureView2" sender:self];
     }];
     */
    //    DAYCYViewController2 *view2 = [self.storyboard instantiateViewControllerWithName:@"SBView2"];
    //    view2.imageView.image = self.takenImage;
    //
    //   view2.imageView = imageToBeShown;
    //    [view2.imageView setImage:imageToBeShown];
    //    [photoToRecognize zoomPhoto];

}

/*
 * -prepareForSegue
 * [Function]カメラが終了したら、Navigation Controllerへ遷移させる。
 * [Data]2013.09.17
 * [Author]Daycy
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segueView2"]) {
        /*画像を保存*/
        if (takenImage && (imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)) {
            UIImageWriteToSavedPhotosAlbum(takenImage, self, nil, nil);
        }
  /*
        view2 = (DAYCYSubViewController *)[segue destinationViewController];
        view2.UIImageBig.image= takenImage;
        view2.UIImageBig.frame = CGRectMake(35,136,view2.UIImageBig.image.size.width, view2.UIImageBig.image.size.height);
   */
    }
}

/*
 * -imagePickerControllerDidCancel
 * [Function]定义相机取消时动作
 * [Data]2013.09.17
 * [Author]Daycy
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
