import UIKit
import SwiftSocket

class ViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  
  let host = "apple.com"
  let port = 80
  var client: TCPClient?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    client = TCPClient(address: host, port: Int32(port))
  }
  
  @IBAction func sendButtonAction() {
    guard let client = client else { return }
    
    switch client.connect(timeout: 10) {
    case .success:
      appendToTextField(string: "Connected to host \(client.address)")
      if let response = sendRequest(string: "GET / HTTP/1.0\n\n", using: client) {
        appendToTextField(string: "Response: \(response)")
      }
    case .failure(let error):
      appendToTextField(string: String(describing: error))
    }
  }
  
  private func sendRequest(string: String, using client: TCPClient) -> String? {
    appendToTextField(string: "Sending data ... ")
    
    switch client.send(string: string) {
    case .success:
      return readResponse(from: client)
    case .failure(let error):
      appendToTextField(string: String(describing: error))
      return nil
    }
  }
  
  private func readResponse(from client: TCPClient) -> String? {
    guard let response = client.read(1024*10) else { return nil }
    
    return String(bytes: response, encoding: .utf8)
  }
  
  private func appendToTextField(string: String) {
    print(string)
    textView.text = textView.text.appending("\n\(string)")
  }

}
