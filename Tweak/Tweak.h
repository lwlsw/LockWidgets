#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>

#define LogDebug(message, ...)                                                 \
  NSLog((@"[LockWidgets] (DEBUG)" message), ##__VA_ARGS__)
#define LogInfo(message, ...)                                                  \
  NSLog((@"[LockWidgets] (INFO)" message), ##__VA_ARGS__)

@interface CSNotificationAdjunctListViewController : UIViewController {
  UIStackView *_stackView;
}

- (void)_didUpdateDisplay;
- (void)_removeItem:(id)arg1 animated:(_Bool)arg2;
- (void)_insertItem:(id)arg1 animated:(_Bool)arg2;
- (void)adjunctListModel:(id)arg1 didRemoveItem:(id)arg2;
- (void)adjunctListModel:(id)arg1 didAddItem:(id)arg2;
- (void)viewWillTransitionToSize:(struct CGSize)arg1
       withTransitionCoordinator:(id)arg2;
- (void)viewDidLayoutSubviews;
- (void)viewWillAppear:(_Bool)arg1;
- (void)viewDidLoad;

@end