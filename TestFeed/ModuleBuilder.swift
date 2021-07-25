//
//  ModuleBuilder.swift
//  TestFeed
//
//  Created by Клим on 23.07.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule() -> UIViewController
}

class ModuleBuilder: AssemblyBuilderProtocol{
    func createMainModule() -> UIViewController {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainVC") as MainViewController
        
        let navVC = UINavigationController(rootViewController: mainVC)
        let presenter = MainPresenter(view: mainVC)
        mainVC.presenter = presenter
        return navVC
    }
    
}
