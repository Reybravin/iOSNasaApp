//
//  AppMainModule.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//


import UIKit

final class AppMainModule : NSObject {

    private let appDIContainer = AppDIContainer()
    private var window: UIWindow?
    private var homeScene : UIViewController?
            
    private lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.providesPresentationContextTransitionStyle = false
        return tabBarController
    }()
    
    func didLaunch(window: UIWindow?, application: UIApplication){
        self.window = window
        AppAppearance.setupAppearance(window: window)

        let startingScene = buildHomeScene()        
        window?.rootViewController = startingScene
        window?.makeKeyAndVisible()
    }
    
}

//MARK: - Navigation

extension AppMainModule {
    
    private func showHomeScene() {
                
        if homeScene == nil {
            let startingScene = self.buildHomeScene()
            window?.rootViewController = startingScene
            window?.makeKeyAndVisible()
            homeScene = startingScene
        } else {
            window?.rootViewController = homeScene
            window?.makeKeyAndVisible()
        }
    }
    
    private func isViewControllerCurrentlyPresented(vc: UIViewController) -> Bool {
        let result = vc.isViewLoaded && vc.view.window != nil
        return result
    }
    
    private func presentByRootViewController(vc: UIViewController){
                
        guard !vc.isBeingPresented else { return }
        
        guard !isViewControllerCurrentlyPresented(vc: vc) else { return }
        
        let rootViewController = UIApplication.shared.keyWindow!.rootViewController
        if let presentedVC = rootViewController?.presentedViewController {
            
            presentedVC.dismiss(animated: true) {
                guard !vc.isBeingPresented else { return }
                guard !self.isViewControllerCurrentlyPresented(vc: vc) else { return }
                rootViewController?.present(vc, animated: true, completion: nil)
            }
        } else {
            rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
}

//MARK: - Factories

extension AppMainModule {

    func buildHomeScene() -> UIViewController {
        
        let homeVC = appDIContainer.makeHomeDIContainer().makeHomeViewController()
        homeVC.tabBarItem = makeBarButtonItem(type: .home)
        
        let secondVC = UIViewController()
        secondVC.tabBarItem = makeBarButtonItem(type: .second)
        
        let controllers = [homeVC, secondVC]
        
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        return tabBarController
        
    }
    
    private func makeBarButtonItem(type: TabBarItem) -> UITabBarItem {
        let tabBarItem = UITabBarItem(tabBarSystemItem: type.itemType, tag: type.tag)
        return tabBarItem
    }
    
}
