//
//  AddQuoteViewController.swift
//  Quotes
//
//  Created by Tomasz Szulc on 10/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Model
import UIKit

class AddQuoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet private var quoteContentTextView: UITextView!
    @IBOutlet private var saidByTextField: UITextField!
    @IBOutlet private var saveButton: UIBarButtonItem!
    @IBOutlet weak var bottomGuideConstraint: NSLayoutConstraint!
    
    private var viewModel = AddQuoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteContentTextView.text = ""
        quoteContentTextView.becomeFirstResponder()
        quoteContentTextView.textContainerInset = UIEdgeInsetsZero
        updateSaveButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textFieldDidChange:"), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
            let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            bottomGuideConstraint.constant = keyboardSize.height
            UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            bottomGuideConstraint.constant = 0
            UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
        }
    }
    
    func textFieldDidChange(notification: NSNotification) {
        updateSaveButton()
    }
    
    private func updateSaveButton() {
        viewModel.contentText = quoteContentTextView.text
        viewModel.saidByText = saidByTextField.text ?? ""
        saveButton.enabled = viewModel.saveButtonEnabled
    }
    
    @IBAction func handleTap(sender: AnyObject) {
        quoteContentTextView.resignFirstResponder()
        saidByTextField.resignFirstResponder()
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        viewModel.contentText = quoteContentTextView.text
        viewModel.saidByText = saidByTextField.text!
        viewModel.saveQuote(CoreDataStack.sharedInstance().mainContext)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        updateSaveButton()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
