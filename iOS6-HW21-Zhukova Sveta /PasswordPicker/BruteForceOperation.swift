
import Foundation

class BruteForceOperation: Operation {
    var password: String
    
    init(password: String) {
        self.password = password
    }
    
    override func main() {
        super.main()
        if isCancelled {
            return
        }
        self.queuePriority = .low
        bruteForce(passwordToUnlock: password)
    }
    
    func bruteForce(passwordToUnlock: String) {
        let characters: [String] = String().printable.map { String($0) }
        var password: String = ""
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: characters)
            print(password)
        }
        print(password)
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var resultString: String = string
        
        if resultString.count <= 0 {
            resultString.append(characterAt(index: 0, array))
        }
        else {
            resultString.replace(at: resultString.count - 1,
                        with: characterAt(index: (indexOf(character: resultString.last!, array) + 1) % array.count, array))
            
            if indexOf(character: resultString.last!, array) == 0 {
                resultString = String(generateBruteForce(String(resultString.dropLast()), fromArray: array)) + String(resultString.last!)
            }
        }
        return resultString
    }
}




