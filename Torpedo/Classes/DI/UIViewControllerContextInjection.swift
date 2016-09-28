#if os(iOS)
    
    
    import UIKit
    
    public class UIKitTorpedoContext {
        public static func configure() {
            UIViewController.context_vc_configure()
            UINavigationController.context_nc_configure()
            UIStoryboard.context_sb_configure()
        }
    }
    
    
    public extension UIViewController {
        
        private static var isFinishedSwizzling = false
        
        private struct AssociatedKeys {
            static var Context = "d_context"
            static var ContextPropertiesInjected = "d_contextPropertiesInjected"
        }
        
        public static func context_vc_configure() {
            if !isFinishedSwizzling {
                isFinishedSwizzling = true
                MethodSwizzler.swizzleSelectorsInClass(self, originalSelector:
                    #selector(UIViewController.viewDidLoad), swizzledSelector: #selector(UIViewController.context_viewDidLoad))
                MethodSwizzler.swizzleSelectorsInClass(self, originalSelector:
                    #selector(UIViewController.prepare(for:sender:)), swizzledSelector: #selector(UIViewController.context_prepare(for:sender:)))
                MethodSwizzler.swizzleSelectorsInClass(self, originalSelector:
                    #selector(UIViewController.show(_:sender:)), swizzledSelector: #selector(UIViewController.context_show(_:sender:)))
                MethodSwizzler.swizzleSelectorsInClass(self, originalSelector:
                    #selector(UIViewController.showDetailViewController(_:sender:)), swizzledSelector: #selector(UIViewController.context_showDetailViewController(_:sender:)))
                MethodSwizzler.swizzleSelectorsInClass(self, originalSelector:
                    #selector(UIViewController.present(_:animated:completion:)), swizzledSelector: #selector(UIViewController.context_present(_:animated:completion:)))
                
            }
        }
        
        //Context Loading
        
        func context_viewDidLoad() {
            context_injectPropertiesIfNotYet(self)
            context_viewDidLoad()
        }
        
        func context_prepare(for segue: UIStoryboardSegue, sender: Any?) {
            context_injectPropertiesIfNotYet(segue.destination)
            context_prepare(for: segue, sender: sender)
        }
        
        func context_show(_ vc: UIViewController, sender: Any?) {
            context_injectPropertiesIfNotYet(vc)
            context_show(vc, sender: sender)
        }
        
        
        func context_showDetailViewController(_ vc: UIViewController, sender: Any?) {
            context_injectPropertiesIfNotYet(vc)
            context_showDetailViewController(vc, sender: sender)
        }
        
        func context_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            context_injectPropertiesIfNotYet(viewControllerToPresent)
            context_present(viewControllerToPresent, animated: flag, completion: completion)
        }
        
        public weak var d_context: Context? {
            get {
                let existingValue = objc_getAssociatedObject(self, &AssociatedKeys.Context)
                if let value = existingValue as? Context {
                    return value
                }
                return nil
            }
            set(newValue) {
                objc_setAssociatedObject(self, &AssociatedKeys.Context, newValue, .OBJC_ASSOCIATION_ASSIGN)
                if let actualStoryboard = storyboard {
                    if !actualStoryboard.isInjectionComplete {
                        d_context?.resolveDependencies(actualStoryboard)
                        actualStoryboard.isInjectionComplete = true
                    }
                }
            }
        }
        
        fileprivate var isInjectionComplete: Bool {
            get {
                let existingValue = objc_getAssociatedObject(self, &AssociatedKeys.ContextPropertiesInjected)
                if let value = existingValue as? Bool {
                    return value
                }
                return false
            }
            set(newValue) {
                objc_setAssociatedObject(self, &AssociatedKeys.ContextPropertiesInjected, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        
        fileprivate func carriedChildren() -> [UIViewController] {
            if let navController = self as? UINavigationController {
                return navController.viewControllers
            } else if let tabController = self as? UITabBarController {
                if let carriedController = tabController.viewControllers {
                    return carriedController
                }
            }
            return []
        }
        
        fileprivate func context_injectPropertiesIfNotYet(_ viewController: UIViewController) {
            if !viewController.isInjectionComplete && d_context != nil {
                d_context?.resolveDependencies(viewController)
                let children = viewController.childViewControllers
                context_injectPropertiesForMany(children)
                context_injectPropertiesForMany(viewController.carriedChildren())
                viewController.isInjectionComplete = true
            }
        }
        
        fileprivate func context_injectPropertiesForMany(_ viewControllers: [UIViewController]) {
            for viewController in viewControllers {
                context_injectPropertiesIfNotYet(viewController)
            }
        }
        
    }
    
    public extension UIStoryboard {
        
        private static var isFinishedSwizzling = false
        
        public static func context_sb_configure() {
            if !isFinishedSwizzling {
                isFinishedSwizzling = true
                MethodSwizzler.swizzleSelectorsInClass(self, originalSelector:
                    #selector(UIStoryboard.instantiateViewController(withIdentifier:)), swizzledSelector: #selector(UIStoryboard.context_instantiateViewController(withIdentifier:)))
            }
        }
        
        func context_instantiateViewController(withIdentifier identifier: String) -> UIViewController {
            let viewController = context_instantiateViewController(withIdentifier: identifier)
            d_context?.resolveDependencies(viewController)
            return viewController
        }
        
        private struct AssociatedKeys {
            static var Context = "d_context"
            static var ContextPropertiesInjected = "d_contextPropertiesInjected"
        }
        
        public weak var d_context: Context? {
            get {
                let existingValue = objc_getAssociatedObject(self, &AssociatedKeys.Context)
                if let value = existingValue as? Context {
                    return value
                }
                return nil
            }
            set(newValue) {
                objc_setAssociatedObject(self, &AssociatedKeys.Context, newValue, .OBJC_ASSOCIATION_ASSIGN)
                
            }
        }
        
        fileprivate var isInjectionComplete: Bool {
            get {
                let existingValue = objc_getAssociatedObject(self, &AssociatedKeys.ContextPropertiesInjected)
                if let value = existingValue as? Bool {
                    return value
                }
                return false
            }
            set(newValue) {
                objc_setAssociatedObject(self, &AssociatedKeys.ContextPropertiesInjected, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        
    }
    
    public extension UINavigationController {
        
        private static var isFinishedSwizzling = false
        
        public static func context_nc_configure() {
            if !isFinishedSwizzling {
                isFinishedSwizzling = true
                MethodSwizzler.swizzleSelectorsInClass(self, originalSelector:
                    #selector(UINavigationController.pushViewController(_:animated:)), swizzledSelector: #selector(UINavigationController.context_pushViewController(_:animated:)))
            }
        }
        
        func context_pushViewController(_ viewController: UIViewController, animated: Bool) {
            context_injectPropertiesIfNotYet(viewController)
            context_pushViewController(viewController, animated: animated)
        }
        
    }
    
#endif
