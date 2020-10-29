import Foundation
import UIKit
import ReactiveSwift
import SalemoveSDK

final class Configuration {
    static let sharedInstance: Configuration = Configuration()

    private var configurationFile: NSDictionary {
        guard let configurationFile = Bundle.main.path(forResource: "Configuration", ofType: "plist") else {
            print("Configuration file not found")
            return NSDictionary()
        }
        print("Configuration file found")

        return NSDictionary(contentsOfFile: configurationFile) ?? NSDictionary()
    }

    var availableEnvironments: [[String: AnyObject]] {
        return Configuration.sharedInstance.configurationFile["environments"] as? [[String: AnyObject]] ?? []
    }

    var availableSites: [[String: AnyObject]] {
        return Configuration.sharedInstance.configurationFile["sites"] as? [[String: AnyObject]] ?? []
    }

    var selectedQueueID: String = "Undefined-Queue"

    var selectedAppToken: String {
        get {
            guard let savedValue = UserDefaults.standard.value(forKey: "appToken") as? String, !savedValue.isEmpty else {
                return "Undefined-Token"
            }
            return savedValue
        }
        set {
            if selectedAppToken != newValue {
                do {
                    try Salemove.sharedInstance.configure(appToken: newValue)
                    UserDefaults.standard.set(newValue, forKey: "appToken")
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    var selectedApiToken: String {
        get {
            guard let savedValue = UserDefaults.standard.value(forKey: "apiToken") as? String, !savedValue.isEmpty else {
                return "Undefined-Token"
            }
            return savedValue
        }
        set {
            if selectedApiToken != newValue {
                do {
                    try Salemove.sharedInstance.configure(apiToken: newValue)
                    UserDefaults.standard.set(newValue, forKey: "apiToken")
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    var selectedEnvironment: String {
        get {
            guard let savedValue = UserDefaults.standard.value(forKey: "baseURL") as? String, !savedValue.isEmpty else {
                return "Undefined-Environment"
            }
            return savedValue
        }
        set {
            if selectedEnvironment != newValue {
                do {
                    try Salemove.sharedInstance.configure(environment: newValue)
                    UserDefaults.standard.set(newValue, forKey: "baseURL")
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    var selectedSiteID: String {
        get {
            guard let savedValue = UserDefaults.standard.value(forKey: "siteID") as? String, !savedValue.isEmpty else {
                return "Undefined-Site"
            }
            return savedValue
        }

        set {
            if selectedSiteID != newValue {
                do {
                    try Salemove.sharedInstance.configure(site: newValue)
                    UserDefaults.standard.set(newValue, forKey: "siteID")
                } catch let error {
                     print(error.localizedDescription)
                }
            }
        }
    }

    var visitorContext: VisitorContext {
        return VisitorContext(type: .page, url: "https://www.salemoveinsurance.com")
    }

    func initialize() throws {
        print("initialize sdk")
        try Salemove.sharedInstance.configure(environment: selectedEnvironment)
        try Salemove.sharedInstance.configure(site: selectedSiteID)
        try Salemove.sharedInstance.configure(apiToken: selectedApiToken)
        try Salemove.sharedInstance.configure(appToken: selectedAppToken)

        Salemove.sharedInstance.configureLogLevel(level: .debug)
    }

    func clearSession() {
        Salemove.sharedInstance.clearSession()
    }
}

class ConfigurationViewController: UIViewController {
    class var storyboardInstance: ConfigurationViewController? {
        return UIStoryboard.configuration.instantiateViewController(withIdentifier: "ConfigurationViewController") as? ConfigurationViewController
    }

    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var environmentLabel: UILabel!

    // MARK: System

    override func viewDidLoad() {
        super.viewDidLoad()

        updateValues()
    }

    // MARK: Initialisation

    // MARK: Public Methods

    @IBAction func applyConfiguration(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func changeEnvironment(_ sender: Any) {
        let controller = UIAlertController(title: "Environment", message: "Please choose", preferredStyle: .actionSheet)

        for env in Configuration.sharedInstance.availableEnvironments {
            guard let environment = env["baseURL"] as? String else { continue }

            let action = UIAlertAction(title: env["description"] as? String, style: .default) { _ in
                Configuration.sharedInstance.selectedEnvironment = environment
                self.updateValues()
            }

             controller.addAction(action)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)

        present(controller, animated: true, completion: nil)
    }

    @IBAction func changeSite(_ sender: Any) {
        let controller = UIAlertController(title: "Site", message: "Please choose", preferredStyle: .actionSheet)

        for site in Configuration.sharedInstance.availableSites {
            guard let siteID = site["siteID"] as? String,
                  let appToken = site["appToken"] as? String,
                  let apiToken = site["apiToken"] as? String else { continue }

            let action = UIAlertAction(title: site["description"] as? String, style: .default) { _ in
                Configuration.sharedInstance.selectedSiteID = siteID
                Configuration.sharedInstance.selectedAppToken = appToken
                Configuration.sharedInstance.selectedApiToken = apiToken
                self.updateValues()
            }

            controller.addAction(action)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)

        present(controller, animated: true, completion: nil)
    }

    @IBAction func clearSession(_ sender: Any) {
        Configuration.sharedInstance.clearSession()
    }

    // MARK: Private methods

    fileprivate func updateValues() {
        let sites = Configuration.sharedInstance.availableSites
        if let site = sites.filter({ $0["siteID"] as? String == Salemove.sharedInstance.site }).first {
            siteLabel.text = site["description"] as? String
        } else {
            siteLabel.text = Salemove.sharedInstance.site
        }

        let environemnts = Configuration.sharedInstance.availableEnvironments
        if let environement = environemnts.filter({ $0["baseURL"] as? String == Salemove.sharedInstance.environment }).first {
            environmentLabel.text = environement["description"] as? String
        } else {
            environmentLabel.text = Salemove.sharedInstance.environment
        }
    }
}
