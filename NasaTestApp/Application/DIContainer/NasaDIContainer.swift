//
//  NasaDIContainer.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import UIKit

final class NasaDIContainer {
    
    private let dependencies: Dependencies
    
    struct Dependencies {
        let apiDataTransferService : DataTransferService
        //let authRepository : AuthRepositoryInterface
        //let accountRepository: AccountRepositoryInterface
        //let configsRepository: ConfigsRepositoryInterface
        //let secureStorage : SecureStorageInterface
        //let defaults: DefaultsServiceInterface
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - Repositories
    func makeNasaDataRepository() -> NasaDataRepositoryInterface {
        return NasaDataRepository(dataTransferService: dependencies.apiDataTransferService
//                                  ,
//                              secureStorage: dependencies.secureStorage,
//                              defaults: dependencies.defaults
        )
    }
    
    //MARK: - Auth
//    func makeAuthViewController() -> UIViewController {
//       return AuthViewController.create(with: makeAuthViewModel(),
//                                        authViewControllersFactory: self)
//    }
//
//    func makeAuthViewModel() -> AuthViewModel {
//        return AuthViewModel(authRepository: dependencies.authRepository,
//                             accountRepository: dependencies.accountRepository,
//                             defaults: dependencies.defaults)
//    }

}
//
//extension AuthDIContainer : AuthViewControllersFactory {
//
//    func makeSetup2faViewController(tfaItem: TFAItem, delegate: Setup2FAViewControllerDelegate?, tfaFlowDelegate: TFAFlowDelegate?) -> UIViewController {
//        let vc = Setup2FAViewController.create(tfaItem: tfaItem,
//                                               viewControllersFactory: self,
//                                               delegate: delegate, tfaFlowDelegate: tfaFlowDelegate)
//        return vc
//    }
//
//    func makeKYCWebView(containerView: UIView, delegate: KYCWebViewViewControllerDelegate?) -> UIViewController {
//        let vc = KYCWebViewViewController.create(containerView: containerView, authRepository: dependencies.authRepository, delegate: delegate)
//        return vc
//    }
//
//    func makeSignUpViewController(delegate: SignUpViewControllerDelegate?) -> UIViewController {
//        let viewModel = SignUpViewModel(authRepository: dependencies.authRepository)
//        let vc = SignUpViewController.create(with: viewModel, authViewControllersFactory: self, delegate: delegate)
//        return vc
//    }
//
//    func makeConfirmEmailViewController() -> UIViewController {
//        let vc = ConfirmEmailViewController()
//        return vc
//    }
//
//    func makeConfirmRegistrationViewController() -> UIViewController {
//        let vc = ConfirmEmailViewController()
//        vc.configureView(titleEn: "We have sent an email to confirm your registration.", titleTh: "ระบบส่งอีเมลยืนยันการสมัครไปยังอีเมลของท่านเรียบร้อยแล้ว")
//        return vc
//    }
//
//    func makeTwoFactorAuthViewController(sessionId: String, email: String) -> UIViewController {
//        return TwoFactorAuthViewController.create(with: sessionId,
//                                                  email: email,
//                                                  authRepository: dependencies.authRepository, accountRepository: dependencies.accountRepository,
//                                                  viewControllersFactory: self)
//    }
//
//    func makeResetPasswordViewController() -> UIViewController {
//        return ResetPasswordViewController.create(authRepository: dependencies.authRepository)
//    }
//
//    func makePromptPinViewController() -> UIViewController {
//        let viewModel = PromptPinViewModel(localStorage: dependencies.secureStorage,
//                                           authRepository: dependencies.authRepository)
//        return PromptPinViewController.create(with: self,
//                                              viewModel: viewModel,
//                                              localStorage: dependencies.secureStorage)
//    }
//
//    func makePromptBiometricAuthViewController() -> UIViewController {
//        let viewModel = PromptBiometriIDViewModel(authRepository: dependencies.authRepository)
//        return PromptBiometriIDViewController.create(with: viewModel,
//                                                     viewControllersFactory: self,
//                                                     localStorage: dependencies.secureStorage)
//    }
//
//    func makeCheckPinViewController() -> UIViewController {
//        let viewModel = CheckPinViewModel(localStorage: dependencies.secureStorage, authRepository: dependencies.authRepository)
//        return EnterPinviewController.create(with: viewModel, viewControllersFactory: self, callback: nil)
//    }
//
//    func makeSetupPinViewController(callback : (()->Void)?) -> UIViewController {
//        let viewModel = SavePinViewModel(localStorage: dependencies.secureStorage,
//                                         authRepository: dependencies.authRepository)
//        return EnterPinviewController.create(with: viewModel, viewControllersFactory: self, callback: callback)
//    }
//
//    func makeDownloadGoogleAuthenticatorViewController(tfaItem: TFAItem, automaticFlow: Bool, viewControllerFactory: AuthViewControllersFactory, delegate: TFAFlowDelegate?) -> UIViewController {
//        let vc = DownloadGoogleAuthenticatorViewController.create(
//            tfaItem: tfaItem,
//            automaticFlow: automaticFlow,
//            viewControllerFactory: self, delegate : delegate)
//        return vc
//    }
//
//    func makeQRCodeGoogleAuthenticatorViewController(tfaItem: TFAItem, delegate: TFAFlowDelegate?) -> UIViewController {
//        return QRCodeGoogleAuthenticatorViewController.create(tfaItem: tfaItem,
//                                                              viewControllersFactory: self, delegate: delegate)
//    }
//
//    func makeEnableGoogle2faViewController(userId: Int, delegate: TFAFlowDelegate?) -> UIViewController {
//        return EnableGoogle2faViewController.create(userId: userId, authRepository: dependencies.authRepository, delegate: delegate)
//    }
//}
