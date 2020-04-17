//
//  MainTabBarController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
//    private let currentUser: MUser
    
//    init(currentUser: MUser = MUser(id: "",
//                                    email: "",
//                                    username: "",
//                                    imageName: "",
//                                    description: "",
//                                    sex: "")) {
//        self.currentUser = currentUser
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainViewController = MainViewController()
        let queueViewController = QueueViewController()
        let controlViewController = ControlViewController()
        
        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
         
        let mainImage = UIImage(systemName: "house", withConfiguration: boldConfig)!
        let queueImage = UIImage(systemName: "list.bullet", withConfiguration: boldConfig)!
        let controlImage = UIImage(systemName: "rectangle.grid.3x2", withConfiguration: boldConfig)!
        
        viewControllers = [
            generateNavigationController(rootViewController: mainViewController, title: "Главная", image: mainImage),
            generateNavigationController(rootViewController: queueViewController, title: "Моя очередь", image: queueImage),
            generateNavigationController(rootViewController: controlViewController, title: "Управление", image: controlImage),
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}

