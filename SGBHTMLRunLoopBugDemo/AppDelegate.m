//
//  AppDelegate.m
//  SGBHTMLRunLoopBugDemo
//
//  Created by Simon Booth on 01/10/2014.
//  Copyright (c) 2014 agbooth.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSAttributedString *attributedString;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.attributedString = [[NSAttributedString alloc] initWithString:@"FAILURE"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] init];
    self.label.numberOfLines = 0;
    
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = self.label;
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // I'm dispatching this asynchronously, so it should happen after we parse the HTML
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.label.attributedText = self.attributedString;
        
    });
    
    NSString *htmlString = @"<html><head>"
                            "<style> h1 { color: green; text-alignment: center; } </style>"
                            "</head><body>"
                            "<h1>SUCCESS</p>"
                            "</body></html>";
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    self.attributedString = [[NSAttributedString alloc] initWithData:htmlData options:@{
                                                                                        
        NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
                                                                                        
    } documentAttributes:nil error:&error];
    
    if (error)
    {
        NSLog(@"Error parsing HTML: %@", error);
    }
}

@end
