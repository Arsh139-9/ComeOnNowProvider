//
//  NavigationManager.swift
//  NewProject
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

struct SSStoryboard {
        
    public static let main: String = "Main"
 
}

struct SSNavigation {
        
    public static let signInOption: String = "navigationSingInOption"
}

class NavigationManager: NSObject {
    
    let window = AppDelegate.shared.window
    
    //------------------------------------------------------
    
    //MARK: Storyboards
    
    let mainStoryboard = UIStoryboard(name: SSStoryboard.main, bundle: Bundle.main)
//    let loaderStoryboard = UIStoryboard(name: SSStoryboard.loader, bundle: Bundle.main)
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = NavigationManager()
    
    //------------------------------------------------------
    
    //MARK: UINavigationController
       
    var signInOptionsNC: UINavigationController {
        return mainStoryboard.instantiateViewController(withIdentifier: SSNavigation.signInOption) as! UINavigationController
    }
    
    //------------------------------------------------------
    
    //MARK: RootViewController
    
    func setupSingInOption() {
        
        let controller = signInOptionsNC
        AppDelegate.shared.window?.rootViewController = controller
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewControllers
    
    public var logInVC: LogInVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: LogInVC.self)) as! LogInVC
    }
    public var forgotPasswordVC: ForgotPasswordVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ForgotPasswordVC.self)) as! ForgotPasswordVC
    }
    public var addAppointmentVC: AddAppointmentVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AddAppointmentVC.self)) as! AddAppointmentVC
    }
    public var changePasswordVC: ChangePasswordVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ChangePasswordVC.self)) as! ChangePasswordVC
    }
    public var editProfileVC: EditProfileVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: EditProfileVC.self)) as! EditProfileVC
    }
    public var tabBarVC: TabBarVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: TabBarVC.self)) as! TabBarVC
    }
    
    public var homeVC: HomeVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as! HomeVC
    }
    
    public var appointmentVC: AppointmentVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AppointmentVC.self)) as! AppointmentVC
    }
    
    public var queueVC: QueueVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: QueueVC.self)) as! QueueVC
    }
    public var profileVC: ProfileVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileVC.self)) as! ProfileVC
    }
    public var notificationVC: NotificationVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: NotificationVC.self)) as! NotificationVC
    }
    public var historyVC: HistoryVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: HistoryVC.self)) as! HistoryVC
    }
    public var scheduledAppointmentVC: ScheduledAppointmentVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ScheduledAppointmentVC.self)) as! ScheduledAppointmentVC
    }
    public var aboutVC: AboutVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AboutVC.self)) as! AboutVC
    }
    public var privacyVC: PrivacyVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: PrivacyVC.self)) as! PrivacyVC
    }
    
    public var serviceVC: ServiceVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: ServiceVC.self)) as! ServiceVC
    }
    public var appointmentDetailsVC: AppointmentDetailsVC {
        return mainStoryboard.instantiateViewController(withIdentifier: String(describing: AppointmentDetailsVC.self)) as! AppointmentDetailsVC
    }
   
    
 
    
    //------------------------------------------------------
}
