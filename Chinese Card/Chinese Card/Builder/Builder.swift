//
//  Builder.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit

class Builder {
    static func createGameModule() -> UIViewController {
        let view = GameViewController()
        let presenter = GamePresenter()
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
