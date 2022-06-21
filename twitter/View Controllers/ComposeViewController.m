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
    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
