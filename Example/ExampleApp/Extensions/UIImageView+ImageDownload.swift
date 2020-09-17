import UIKit

extension UIImageView {
    func setImage(using url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: data)
            }
        }

        dataTask.resume()
    }
}
