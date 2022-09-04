//
//  SceneDelegate.swift
//  Exitek iOS Developer Tech Task
//
//  Created by Сергей Веретенников on 04/09/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager().saveContext()
    }
}

