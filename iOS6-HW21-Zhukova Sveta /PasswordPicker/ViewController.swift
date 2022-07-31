

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var switchColorButton: UIButton!
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                self.infoLabel.textColor = .white
            } else {
                self.view.backgroundColor = .white
                self.infoLabel.textColor = .black
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingButton()
    }
    
    func settingButton() {
        activityIndicator.isHidden = true
        infoLabel.font = .systemFont(ofSize: 13)
        infoLabel.text = "Создать пароль"
        infoLabel.textColor = .black
        generateButton.backgroundColor = .systemBlue
        generateButton.tintColor = .white
        switchColorButton.backgroundColor = .systemGreen
        switchColorButton.tintColor = .white
    }

    @IBAction func generateButtonPressed(_ sender: Any) {
        textField.isSecureTextEntry = true
        textField.text = generatePassword(length: 3)
        generateButton.isUserInteractionEnabled = false
        generateButton.backgroundColor = .systemGray2
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        switchColorButton.isHidden = false
        let backgroundQueue = OperationQueue()
        let bruteForceOperation = BruteForceOperation(password: textField.text ?? "")
        let mainQueue = OperationQueue.main
        let bruteForceCompletion = BlockOperation {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.textField.isSecureTextEntry = false
            self.generateButton.isUserInteractionEnabled = true
            self.generateButton.isSelected = false
            self.generateButton.backgroundColor = .systemBlue
            self.switchColorButton.isHidden = true
        }
        backgroundQueue.addOperation(bruteForceOperation)
        bruteForceOperation.completionBlock = {
            mainQueue.addOperation(bruteForceCompletion)
        }
    }
    
    @IBAction func changeColorPressed(_ sender: Any) {
        isBlack.toggle()
    }
    
    func generatePassword(length: Int) -> String {
        let characters = String().letters + String().digits
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}

extension String {
    var digits: String { return "0123456789" }
    var lowercase: String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase: String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters: String { return lowercase + uppercase }
    var printable: String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}



