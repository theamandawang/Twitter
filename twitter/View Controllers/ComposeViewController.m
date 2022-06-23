//
//  ComposeViewController.m
//  twitter
//
//  Created by Amanda Wang on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
- (IBAction)onCloseModal:(id)sender;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    // Do any additional setup after loading the view.
}
- (IBAction)onTapMainView:(id)sender {
    [self.view endEditing:true];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.textView.text stringByReplacingCharactersInRange:range withString:text];

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
    // TODO: Allow or disallow the new text
}
- (IBAction)onTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet * tweet, NSError *error) {
        if (tweet) {
            [self dismissViewControllerAnimated:true completion:nil];
            [self.delegate didTweet:tweet];
        } else {
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
    }];
}
- (IBAction)onCloseModal:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
