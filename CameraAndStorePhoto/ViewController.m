//
//  ViewController.m
//  CameraAndStorePhoto
//
//  Created by Tim on 2016/8/24.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIImageView *imagePicked;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)CameraBtnPressed:(UIButton *)sender {
    
    //Check if the Camera is available on the device (as Source Type)
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        //declare a variable of UIImagePickerController, we need it to process the rest of the code
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        //Set the image picker’s delegate
        picker.delegate = self;
        
        //Set the image picker’s source type (again, the Camera)
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //Here we tell our image picker to not edit a captured picture, which means that we won’t get the black screen with a square frame right after we’ve took a picture
        picker.allowsEditing = false;
        
        //Finally we present the camera controller with a standard animation from the bottom of the screen
        [self presentViewController:picker animated:true completion:nil];
    }
}

- (IBAction)openLibrary:(UIButton *)sender {
    
    //Check if Photo Library is available on device
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //Set the image picker’s source type
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        //we tell our image picker we want to edit our picked image, which means that we will get a black window with a square frame where we can zoom and move our photo
        picker.allowsEditing = true;
        [self presentViewController:picker animated:true completion:nil];
    }
}

//add a UIImagePicker delegate in order to tell our app to get the chosen image and place it into the main screen UIImageView
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //取得user 拍下的照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //顯示在頁面上
    _imagePicked.image = image;
    
    //dismiss the controller (camera or photo library) and get back to our main screen
    [self dismissViewControllerAnimated:true completion:nil];
}

// Save button method
- (IBAction)saveImageButton:(id)sender {
    
    //壓縮照片品質至0.6
    NSData *imageData = UIImageJPEGRepresentation(_imagePicked.image, 0.6);
    UIImage *compressedJPGImage = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(compressedJPGImage, self, @selector(image:didFinishSave:contextInfo:), nil);
    
    
    
}

#pragma mark 存好照片時發出通知
-(void)image:(UIImage*)image didFinishSave:(NSError*)error contextInfo:(NSDictionary*)info{
    
    if(error != nil){
        [self showAlert:[NSString stringWithFormat:@"Error :%@",error]];
    }else{
        [self showAlert:@"相片儲存成功！"];
    }
    
}


-(void)showAlert:(NSString*)message{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:true completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
