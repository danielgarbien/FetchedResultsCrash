//
//  ContainmentWithAutoLayout.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 23/02/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     Add childController with no transition.
     Embeds its view in container.
     Calls didMoveToParentViewController on childController at a last step.
     */
    func addImmediatelyChildViewController(childController: UIViewController, embeddedInView container: UIView) {
        addChildViewController(childController)
        container.embedSubview(childController.view)
        childController.didMoveToParentViewController(self)
    }
    
    func removeImmediatelyFromParentViewController() {
        willMoveToParentViewController(nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}

extension UIView {
    
    func embedSubview(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraintsForItem(view, withEqualFrameAsItem: self)
    }
}

extension NSLayoutConstraint {
    
    static func activateConstraintsForItem(item: AnyObject, withEqualFrameAsItem secondItem: AnyObject) {
        activateConstraints(
            constraintsForItem(
                item,
                withEqualAttributes: [.Left, .Right, .Top, .Bottom],
                toItem: secondItem)
        )
    }
    
    static func constraintsForItem(item: AnyObject, withEqualAttributes attributes: [NSLayoutAttribute], toItem: AnyObject) -> [NSLayoutConstraint] {
        return attributes.map {
            return self.init(item: item, attribute: $0, relatedBy: .Equal, toItem: toItem, attribute: $0, multiplier: 1, constant: 0)
        }
    }
}
