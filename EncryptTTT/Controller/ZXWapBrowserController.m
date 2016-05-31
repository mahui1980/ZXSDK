

#import "ZXWapBrowserController.h"


@implementation ZXWapBrowserController
@synthesize delegate;
@synthesize wapSiteUrl;
//@synthesize parentViewControllerForBrowser;
@synthesize refreshItem, stopItem;
@synthesize webView = webView;
#define kExpandButtonWidth      47
#define getScreenWidthFromOrientation(ori) (ori == UIInterfaceOrientationLandscapeLeft || ori == UIInterfaceOrientationLandscapeRight)? [UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width

#pragma mark - View lifecycle

static ZXWapBrowserController *_wapBrowserController = nil;

#pragma mark -
#pragma mark -----------------------------------System method---------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad
{
    // Add NavigationBar
	//NSUInteger navBarHeight = 0;
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
//    isWebViewLoaded = NO;
    _orientation = self.interfaceOrientation;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    
    //    navBarHeight = 44;
    //    UINavigationBar *tempNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navBarHeight)];
    //    tempNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    //    navBar = tempNavBar;
    //    [self.view addSubview:tempNavBar];
    //    [tempNavBar release];
    
    //	if ([self.parentViewControllerForBrowser isKindOfClass:[UINavigationController class]]) {
    //		navBar = ((UINavigationController *)self.parentViewControllerForBrowser).navigationBar;
    //	} else {
    //		navBarHeight = 44;
    //		UINavigationBar *tempNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navBarHeight)];
    //		tempNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    //		navBar = tempNavBar;
    //		[self.view addSubview:tempNavBar];
    //		[tempNavBar release];
    //	}
    
	//[self showNavItemWithTitle:@""];
	
    // Add WebView
    UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];//CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height-navBarHeight)];
    tempWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tempWebView.scalesPageToFit = YES;
	tempWebView.userInteractionEnabled = YES;
	tempWebView.multipleTouchEnabled = YES;
	tempWebView.delegate = self;
    [tempWebView setBackgroundColor:[UIColor clearColor]];
    [tempWebView setOpaque:NO];
    webView = tempWebView;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempWebView];
    [self addActivityView];
    
    // Add ToolBar
    CGFloat screenWidth = getScreenWidthFromOrientation(_orientation);
    ACWebBrowserToolBar *tempToolBar = [[ACWebBrowserToolBar alloc] initWithFrame:CGRectMake(screenWidth-kExpandButtonWidth, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    tempToolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    tempToolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar = tempToolBar;
    [self.view addSubview:tempToolBar];
    
    // Add Bar Buttons
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"adchina_back"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goBack)];
	UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"adchina_forward"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goForward)];
    //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goForward)];
	UIBarButtonItem *stopButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"adchina_stoploading"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(stopload)];
    //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopload)];
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(done:)] ;
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"adchina_hide"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(expand:)];
    self.expandItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"adchina_expand"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(expand:)];
	nextButton.style = UIBarButtonItemStylePlain;
	stopButton.style = UIBarButtonItemStylePlain;
	refreshButton.style = UIBarButtonItemStylePlain;
    self.refreshItem = refreshButton;
    self.stopItem = stopButton;
    [toolBar setItems:[NSArray arrayWithObjects:self.expandItem, flex, backButton, flex, nextButton, flex, refreshButton, flex, hideButton, nil]
             animated:NO];

    
	[self loadWapSiteWithUrl:self.wapSiteUrl];
}


// Add Activity View
-(void) addActivityView {
    self.actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    self.actView.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    self.actView.center = CGPointMake(webView.bounds.size.width/2, webView.bounds.size.height/2);
    self.actView.hidesWhenStopped = YES;
    [webView addSubview:self.actView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[webView stopLoading];
//    webView.delegate = nil;
//    self.wapSiteUrl = nil;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    navBar = nil;
    toolBar = nil;
    webView = nil;
    self.refreshItem = nil;
    self.stopItem = nil;
}

+ (ZXWapBrowserController *)sharedWapBrowserController {
    if (!_wapBrowserController) {
        _wapBrowserController = [[ZXWapBrowserController alloc] init];
    }
    return _wapBrowserController;
}

+ (void)clearOldWapBrowser {

    if (_wapBrowserController) {
        if ([_wapBrowserController.view superview]) {
            [_wapBrowserController.view removeFromSuperview];
        }
        _wapBrowserController = nil;
    }
}
#pragma mark -web控制
#pragma mark -----------------------------------Web control---------------------------------------
- (void)setOpaqueForWebView:(BOOL)isOpaque {
    if (isOpaque) {
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setOpaque:NO];
    } else {
        [webView setBackgroundColor:[UIColor grayColor]];
        [webView setOpaque:YES];
    }
}

- (void)done:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[webView stopLoading];
    webView.delegate = nil;
    self.wapSiteUrl = nil;
    
//    if (self.parentViewControllerForBrowser && [self.parentViewControllerForBrowser respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
//        [self.parentViewControllerForBrowser dismissModalViewControllerAnimated:YES];
//    }
    
    if (self.delegate) {
        [delegate didFinishBrowsingWapSite];
        self.delegate = nil;
    }
    
    [ZXWapBrowserController clearOldWapBrowser];
}

- (void)showNavItemWithTitle:(NSString *)itemTitle
{	
    //	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    //	
    //    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:itemTitle];	
    //    navItem.rightBarButtonItem = btnDone;
    //    [navBar popNavigationItemAnimated:NO];
    //    [navBar pushNavigationItem:navItem animated:NO];
    //    [navItem release];
    
    //	if ([self.parentViewControllerForBrowser isKindOfClass:[UINavigationController class]]) {
    //		self.title = itemTitle;
    //		
    //		// Get superViewController from NavigationController
    //		UIViewController *superViewController = nil;
    //		for (int i = 0; i < [self.navigationController.viewControllers count]; i++) {
    //			if ([self.navigationController.viewControllers objectAtIndex:i] == self && i > 0) {
    //				superViewController = [self.navigationController.viewControllers objectAtIndex:i-1];
    //				break;
    //			}
    //		}
    //		
    //		if (!superViewController.title.length) {
    //			self.navigationItem.rightBarButtonItem = btnDone;
    //		} else {
    //			self.navigationItem.rightBarButtonItem = nil;
    //		}
    //
    //	} else {
    //		UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:itemTitle];	
    //		navItem.rightBarButtonItem = btnDone;
    //		[navBar popNavigationItemAnimated:NO];
    //		[navBar pushNavigationItem:navItem animated:NO];
    //		[navItem release];
    //	}
	
    //	[btnDone release];
}
/*重设toolbar*/
- (void)reloadToolbarForState:(WapBrowserLoadingState)loadingState
{
    switch (loadingState) {
        case StateBeginLoading:
        {
            // Disable next/back, Show stop button
            UIBarButtonItem *backItem = [[toolBar items] objectAtIndex:BackItemIndex];
            UIBarButtonItem *nextItem = [[toolBar items] objectAtIndex:NextItemIndex];
            backItem.enabled = [webView canGoBack];
            nextItem.enabled = [webView canGoForward];
            
            NSMutableArray *arrItems = [NSMutableArray arrayWithArray:toolBar.items];
            [arrItems replaceObjectAtIndex:BackItemIndex withObject:backItem];
            [arrItems replaceObjectAtIndex:NextItemIndex withObject:nextItem];
            [arrItems replaceObjectAtIndex:RefreshItemIndex withObject:self.stopItem];
            
            [toolBar setItems:[NSArray arrayWithArray:arrItems] animated:NO];
        }
            break;
        case StateStopLoading:
        {
            // Set next/back, Show refresh button
            UIBarButtonItem *backItem = [[toolBar items] objectAtIndex:BackItemIndex];
            UIBarButtonItem *nextItem = [[toolBar items] objectAtIndex:NextItemIndex];
            backItem.enabled = [webView canGoBack];
            nextItem.enabled = [webView canGoForward];
            
            NSMutableArray *arrItems = [NSMutableArray arrayWithArray:toolBar.items];
            [arrItems replaceObjectAtIndex:BackItemIndex withObject:backItem];
            [arrItems replaceObjectAtIndex:NextItemIndex withObject:nextItem];
            [arrItems replaceObjectAtIndex:RefreshItemIndex withObject:self.refreshItem];
            
            [toolBar setItems:[NSArray arrayWithArray:arrItems] animated:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)goBack
{
	[webView goBack];
}

- (void)goForward
{
	[webView goForward];
}

- (void)reload
{
	[webView reload];
}

- (void)stopload
{
	[webView stopLoading];
}
/*显示show tool bar 动画*/
- (void)animatedShowToolBar:(BOOL)show {
    CGRect toolBarFrame = toolBar.frame;
    if (show) {
        toolBarFrame.origin.x = 0;
    } else {
        CGFloat width = getScreenWidthFromOrientation(_orientation);
        toolBarFrame.origin.x = width-kExpandButtonWidth;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    toolBar.frame = toolBarFrame;
    [UIView commitAnimations];
}
/*显示隐藏toolBar方法*/
- (void)expand:(id)sender {
//    UIBarButtonItem *expandItem = [[toolBar items] objectAtIndex:0];
    if (toolBar.frame.origin.x == 0) {
        NSMutableArray *arrItems = [NSMutableArray arrayWithArray:toolBar.items];
        [arrItems replaceObjectAtIndex:0 withObject:self.expandItem];
        [toolBar setItems:[NSArray arrayWithArray:arrItems] animated:NO];
        [self animatedShowToolBar:NO];
    } else {
        NSMutableArray *arrItems = [NSMutableArray arrayWithArray:toolBar.items];
        [arrItems replaceObjectAtIndex:0 withObject:self.closeItem];
        [toolBar setItems:[NSArray arrayWithArray:arrItems] animated:NO];
        [self animatedShowToolBar:YES];
    }
}

- (void)loadWapSiteWithUrl:(NSString *)url
{
    [self.actView startAnimating];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


#pragma mark -方向控制
#pragma mark -----------------------------------Orientation control---------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (BOOL)shouldAutorotate {
	return YES;
}

// Not used for transparent web browser
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[webView setNeedsDisplay];
}

// Used for current transparent web browser
- (void)didRotate:(NSNotification *)notification {
    [webView setNeedsDisplay];
    int ori = [(NSNumber *)[[notification userInfo] objectForKey:UIApplicationStatusBarOrientationUserInfoKey] intValue];
    _orientation = ori;
    

    if (toolBar.frame.origin.x != 0.0f) {
        CGRect toolBarFrame = toolBar.frame;
        CGFloat screenWidth = getScreenWidthFromOrientation(_orientation);
        toolBarFrame.origin.x = screenWidth-kExpandButtonWidth;
        toolBar.frame = toolBarFrame;
    }
}

#pragma mark -webview代理方法
#pragma mark -----------------------------------WebView delegate---------------------------------------
- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL bReturn = NO;
    NSString *url = [[[request URL] absoluteString] lowercaseString];
    Boolean bFindAppStringInfo = NO;
    NSArray *array = [NSArray arrayWithObjects:@"https://itunes.apple.com/",@"itms://",@"itms-apps://",@"http://itunes.apple.com/", nil];
    for(NSString *strTemp in array){
        if ([url hasPrefix:strTemp]) {
            bFindAppStringInfo = YES;
            break;
        }
    }
    if (!bFindAppStringInfo) {

        return YES;
    } else {

            [self.delegate didFinishBrowsingWapSite];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return NO;
    }
    
    return bReturn;
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self reloadToolbarForState:StateBeginLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [self.actView stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self reloadToolbarForState:StateStopLoading];
    
//    if (!isWebViewLoaded) {
//        [webView stringByEvaluatingJavaScriptFromString:@"if(typeof sdkDeviceInfo != 'undefined'){sdkDeviceInfo.setDisplay('notice', {'display':'ios'});"];
//        [webView stringByEvaluatingJavaScriptFromString:@"if(typeof sdkDeviceInfo != 'undefined'){sdkDeviceInfo.fireEvent('notice', {'action':'setDisplay','display':'ios'})};window.open('adchinasdk:supports:');window.open('adchinasdk:startblow:');"];
//        isWebViewLoaded = YES;
//    }
//    [self.delegate setAudioSessionCategory];
//    [self.delegate addBlowEventForWebView:theWebView];
}

- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error
{
    [self.actView stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self reloadToolbarForState:StateStopLoading];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

@end
