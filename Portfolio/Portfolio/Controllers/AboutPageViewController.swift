//
//  ViewController.swift
//  Onboard
//
//  Created by GEORGE QUENTIN on 12/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import AppCore

public struct WalkthroughModel {
    public let pages : [WalkthroughPageModel]
}

public struct WalkthroughPageModel {
    public let lottieAnimation : String
    public let title : String
    public let description : String
}

class AboutPageViewController: UIPageViewController {

    fileprivate var walkthroughModel: WalkthroughModel {
        return WalkthroughModel(pages:
            [WalkthroughPageModel(lottieAnimation: "car", title: "Hello", description: ""),
             WalkthroughPageModel(lottieAnimation: "dna_like_loader", title: "Weather", description: ""),
             WalkthroughPageModel(lottieAnimation: "motorcycle", title: "Books", description: ""),
             WalkthroughPageModel(lottieAnimation: "PinJump", title: "Calendar", description: "")])
    }
    public var numberOfPages = 0
    public var pageIndex = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(#function) \(self.className)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        numberOfPages = walkthroughModel.pages.count
        pageIndex = 0
        
        // Create the first screen
        if let startingViewController = self.pageViewController(atIndex: pageIndex) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // Mark: - Get a view controller
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    // Mark: - Get the Next View Controller
    func goToNextPageViewController(withIndex  index: Int, animated: Bool = true) {
        if let walkthroughviewController = self.pageViewController(atIndex: (index + 1)) {
            setViewControllers([walkthroughviewController], direction: .forward, animated: animated, completion: nil)
        }else{
            print("We are on the last page")
        }
    }
    
    // Mark: - Get the Previous View Controller
    func goToPreviousPageViewController(withIndex  index: Int, animated: Bool = true){
        if let walkthroughviewController = self.pageViewController(atIndex: (index - 1)) {
            setViewControllers([walkthroughviewController], direction: .reverse, animated: animated, completion: nil)
        }else{
            print("We are on the First page")
        }
    }
    
    // Mark: - Set the current view controller properties
    fileprivate func pageViewController(atIndex index: Int) -> UIViewController? {
        
        if index == NSNotFound || index < 0 || index >= numberOfPages {
            return nil
        }
        
        if index < numberOfPages  {
            let page = self.getViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
            let model = walkthroughModel.pages[index]
            page.loadViewIfNeeded()
            page.view.setNeedsLayout()
            page.view.layoutIfNeeded()
            
            page.animation(with: model.lottieAnimation)
            page.titleLabel.text = model.title
            page.descriptionLabel.text = model.description
            page.pageControl.numberOfPages = walkthroughModel.pages.count
            page.pageControl.currentPage = index
            pageIndex = index
            return page
        }
        
        return nil
    }
    
    deinit {
        print("\(#function) \(self.className)")
    }
}

extension AboutPageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if pageIndex > 0 {
            return self.pageViewController(atIndex: (pageIndex - 1) )
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if (pageIndex + 1) < numberOfPages {
            return self.pageViewController(atIndex: (pageIndex + 1) )
        }
        
        return nil
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return numberOfPages
    }
   
}

extension AboutPageViewController: UIPageViewControllerDelegate { }


