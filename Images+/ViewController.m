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
    self.editButton.enabled = NO;
}

- (IBAction)showEditActions:(id)sender {
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Image options"];
    
    [attributedTitle addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:28.0]
                            range:NSMakeRange(0, 13)];
    
    [actionSheet setValue:attributedTitle forKey:@"attributedTitle"];

    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self editImage];
    }];
    
    [actionSheet addAction:edit];
    
    
    UIAlertAction *revert = [UIAlertAction actionWithTitle:@"Revert to original" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self revertToOriginal];
    }];
    
    [actionSheet addAction:revert];
    
    UIAlertAction *discard = [UIAlertAction actionWithTitle:@"Discard image" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self discardImage];
    }];
    
    [actionSheet addAction:discard];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [actionSheet addAction:cancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (IBAction)showActions:(id)sender {
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.backgroundImage.image] applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
 }

- (IBAction)showAddImages:(id)sender {
    
    UIAlertController *addMedia = [UIAlertController alertControllerWithTitle:@"Add Image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Add Image"];
    
    [attributedTitle addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:28.0]
                            range:NSMakeRange(0, 9)];
    
    [addMedia setValue:attributedTitle forKey:@"attributedTitle"];
    
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

- (void)emailImage {
    if ([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:@"Images+ image"];
        
        NSData *attachmentAsData = UIImagePNGRepresentation(self.backgroundImage.image);
        
        [mailComposer addAttachmentData:attachmentAsData mimeType:@"image/png" fileName:@"Images+.png"];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
        
    }
}

- (void)saveToLibrary {
    UIImageWriteToSavedPhotosAlbum(self.backgroundImage.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
}

- (void)revertToOriginal {
    self.backgroundImage.image = self.originalImage;
}

- (void)discardImage {
    self.backgroundImage.image = nil;
    
    self.actionsButton.enabled = NO;
    self.editButton.enabled = NO;

}

- (void)editImage {
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:self.backgroundImage.image];
    
    editor.delegate = self;
    
    [self presentViewController:editor animated:YES completion:nil];
    
}

- (void)takePicture {
    
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

- (void)chooseImageFromLibrary {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    
    NSString *message;
    
    NSString *titleMessage;
    
    if (!error) {
        message = @"Saved image to library";
        titleMessage = @"Success";
    } else {
        message = @"Error saving image to library";
        titleMessage = @"Error";
    }
    
    UIAlertController *imageAlert = [UIAlertController alertControllerWithTitle:titleMessage message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [imageAlert addAction:okAction];
    
    [self presentViewController:imageAlert animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *message;
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    if (result == MFMailComposeResultSent) {
        message = @"Email sent";
    } else if (result == MFMailComposeResultCancelled) {
        message = @"Send cancelled";
    } else if (result == MFMailComposeResultSaved) {
        message = @"Message saved";
    } else if (result == MFMailComposeResultFailed) {
        message = @"Failed to send";
    }
    
    UIAlertController *uac = [UIAlertController alertControllerWithTitle:@"Email status" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [uac addAction:okAction];
    
    [self presentViewController:uac animated:YES completion:nil];
}

#pragma mark - ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.actionsButton.enabled = YES;
    self.editButton.enabled = YES;
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    self.originalImage = chosenImage;
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:chosenImage];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
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
