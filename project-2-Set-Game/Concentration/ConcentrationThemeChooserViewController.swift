//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Tomer Kobrinsky on 25/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController/*, UISplitViewControllerDelegate*/ {
    
    static let themeNameToIndex = ThemeNameToIndex()
    
    private var lastUsedConcentrationViewController: ConcentrationViewController?
    
    @IBAction func changeTheme(_ sender: Any) {
        // if we used a concentrationViewController before,
        // then we push it to the navigationController stack & and change the theme
        if let concentrationViewController = lastUsedConcentrationViewController {
            setThemeIndexByButtonTitle(button: sender, concentrationViewController, ())
            navigationController?.pushViewController(concentrationViewController, animated: true)
        }
            // else we segue to a concentrationViewController
        else {
            performSegue(withIdentifier: "chooseTheme", sender: sender)
        }
    }
    private func setThemeIndexByButtonTitle(button sender: Any?,_ concentrationViewController: ConcentrationViewController,_ additionalOperation: ()?) {
        if let themeName = (sender as? UIButton)?.currentTitle, let themeIndex = ConcentrationThemeChooserViewController.themeNameToIndex[themeName] {
            concentrationViewController.themeIndex = themeIndex
            additionalOperation
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseTheme" {
            if let concentrationViewController = segue.destination as? ConcentrationViewController {
                setThemeIndexByButtonTitle(button: sender, concentrationViewController, {
                    lastUsedConcentrationViewController = concentrationViewController
                }())
            }
        }
    }
}



