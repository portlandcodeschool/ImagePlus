//
//  ViewController.m
//  Images+
//
//  Created by Erick Bennett on 1/8/15.
//  Copyright (c) 2015 Erick Bennett. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.actionsButton.enabled = NO;
}

- (IBAction)showActions:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Image options"];
    
    [attributedTitle addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:28.0]
                            range:NSMakeRange(0, 13)];
    
    [actionSheet setValue:attributedTitle forKey:@"attributedTitle"];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save to library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [actionSheet addAction:save];
    
    UIAlertAction *email = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [actionSheet addAction:email];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self editImage];
    }];
    
    [actionSheet addAction:edit];
    
    
    UIAlertAction *revert = [UIAlertAction actionWithTitle:@"Revert to original" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [actionSheet addAction:revert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Discard image" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    
    [actionSheet addAction:cancel];
    
    UIAlertAction *discard = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [actionSheet addAction:discard];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)editImage {
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:self.backgroundImage.image];
    editor.delegate = self;
    
    [self presentViewController:editor animated:YES completion:nil];
    
}

- (IBAction)showAddImages:(id)sender {
    
    UIAlertController *addMedia = [UIAlertController alertControllerWithTitle:@"Add Image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chooseImageFromLibrary];
    }];
    
    [addMedia addAction:library];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePicture];
    }];
    
    [addMedia addAction:camera];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [addMedia addAction:cancel];
    
    [self presentViewController:addMedia animated:YES completion:nil];
}

-(void) takePicture {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        
        UIAlertController *noCamera = [UIAlertController alertControllerWithTitle:@"Camera Error!" message:@"No camera available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [noCamera addAction:confirm];
        
        [self presentViewController:noCamera animated:YES completion:nil];
        
    }
    
}

-(void) chooseImageFromLibrary {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - ImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.actionsButton.enabled = YES;
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    self.originalImage = chosenImage;
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:chosenImage];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - CLImageEditorDelegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    self.backgroundImage.image = image;
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
