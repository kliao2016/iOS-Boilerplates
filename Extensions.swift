extension UIColor {

    struct CustomColors {
        static let lead = UIColor.rgb(red: 30, green: 30, blue: 30)
        static let customLightOrange = UIColor.rgb(red: 255, green: 138, blue: 101)
        static let customOrange = UIColor.rgb(red: 255, green: 112, blue: 67)
        static let customDarkOrange = UIColor.rgb(red: 244, green: 81, blue: 30)
        static let whiteSmoke = UIColor.rgb(red: 245, green: 245, blue: 245)
        static let ghostWhite = UIColor.rgb(red: 248, green: 248, blue: 255)
    }

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    // Shortcut and modularized code for adding constraints
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict[key] = view
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}

extension UIImageView {
    // Function to cache images
    func loadImagesUsingCacheWithUrlString(urlString: String) {
        let imageCache = NSCache<AnyObject, AnyObject>()

        self.image = nil

        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }

        // Otherwise fire off new download
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }).resume()
    }
}