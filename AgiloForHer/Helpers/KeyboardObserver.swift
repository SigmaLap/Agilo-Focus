//import SwiftUI
//import Combine
//
///// Observes keyboard appearance and provides the keyboard height
//final class KeyboardObserver: ObservableObject {
//    @Published var keyboardHeight: CGFloat = 0
//    @Published var isKeyboardVisible: Bool = false
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        setupKeyboardListeners()
//    }
//
//    private func setupKeyboardListeners() {
//        let keyboardWillShow = NotificationCenter.default
//            .publisher(for: UIResponder.keyboardWillShowNotification)
//            .compactMap { notification -> CGFloat? in
//                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//                    return nil
//                }
//                return keyboardFrame.height
//            }
//
//        let keyboardWillHide = NotificationCenter.default
//            .publisher(for: UIResponder.keyboardWillHideNotification)
//            .map { _ -> CGFloat in 0 }
//
//        Publishers.Merge(keyboardWillShow, keyboardWillHide)
//            .debounce(for: 0.01, scheduler: RunLoop.main)
//            .sink { [weak self] height in
//                withAnimation(.easeOut(duration: 0.25)) {
//                    self?.keyboardHeight = height
//                    self?.isKeyboardVisible = height > 0
//                }
//            }
//            .store(in: &cancellables)
//    }
//}
