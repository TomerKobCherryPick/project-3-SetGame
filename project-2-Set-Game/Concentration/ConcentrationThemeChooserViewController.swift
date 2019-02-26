//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Tomer Kobrinsky on 25/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    static let themeNameToIndex = ThemeNameToIndex()
    
    private var lastUsedConcentrationViewController: ConcentrationViewController?
    
    private var splitViewDetailViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        if let concentrationViewController = secondaryViewController as? ConcentrationViewController {
            if concentrationViewController.themeIndex == nil {
                return true
            } else {
                lastUsedConcentrationViewController = concentrationViewController
            }
        }
        
        return false
    }
    @IBAction func changeTheme(_ sender: Any) {
        // if concentrationViewController is the detail, then we just change the theme
        if let concentrationViewController = splitViewDetailViewController {
            setThemeIndexByButtonTitle(sender: sender, concentrationViewController: concentrationViewController, ())
        }
            // else, if used a concentrationViewController before,
            // then we just push it to the navigationController stack
        else if let concentrationViewController = lastUsedConcentrationViewController {
            setThemeIndexByButtonTitle(sender: sender, concentrationViewController: concentrationViewController, ())
            navigationController?.pushViewController(concentrationViewController, animated: true)
        }
            // else we segue to a concentrationViewController
        else {
            performSegue(withIdentifier: "chooseTheme", sender: sender)
        }
    }
    private func setThemeIndexByButtonTitle(sender: Any?, concentrationViewController: ConcentrationViewController,_ additionalOperation: ()?) {
        if let themeName = (sender as? UIButton)?.currentTitle, let themeIndex = ConcentrationThemeChooserViewController.themeNameToIndex[themeName] {
            concentrationViewController.themeIndex = themeIndex
            additionalOperation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseTheme" {
            if let concentrationViewController = segue.destination as? ConcentrationViewController {
                setThemeIndexByButtonTitle(sender: sender, concentrationViewController: concentrationViewController, {
                    lastUsedConcentrationViewController = concentrationViewController
                }())
            }
        }
    }
}



