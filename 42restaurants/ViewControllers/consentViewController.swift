//
//  consentViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/08.
//

import UIKit

class ConsentViewController: UIViewController {

    @IBOutlet weak var consentSwitch: UISwitch!
    @IBOutlet weak var consentDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(isHidden: true)
        checkIfAlreadyAgreed()
        setConsentLabelText()
    }
    
    private func checkIfAlreadyAgreed() {
        var isAgreed: Bool = false
        isAgreed = UserDefaults.standard.bool(forKey: "isConsentAgreed")
        if isAgreed == true {
            goToMainPage()
        }
    }
    
    private func setConsentLabelText() {
        self.consentDescriptionLabel.text = """
        42 restaurants 이용약관\n
        \n
        제 1조
        \n
        42 restaurants(이하 '해당 앱')의 사용자는 다음 사항을 동의합니다.
        \t 1. 불쾌하거나 기분 나쁜 컨텐츠( 노출, 외설물, 비속어와 같은 부적절한 콘텐츠 등)를 접할 수도 있다.\n
        \t 2. 42 restaurants는 (사소한 사항이라도) 불쾌하다고 신고 받은 컨텐츠 및 컨텐츠를 올린 사용자를 관용 없이 제재할 것입니다.\n
        \t 3. 사용자는 언제든지 불쾌한 컨텐츠를 신고할 수 있다.\n
        \t 4. 사용자들로부터 10회 이상 불쾌하다고 신고받은 컨텐츠는 그 즉시 삭제한다.\n
        \t 5. 사용자들로부터 10회 이상 불쾌하다고 신고받은 컨텐츠를 올린 사람에 대해 더 이상 글을 쓸 수 없도록 조치하는 것을 24시간 이내에 수행한다.\n
        \t 6. 사용자가 올린 이미지 및 텍스트, 별점 등의 정보는 앱 이외의 사항에 사용하지 않는다.\n
        
        \n
        제 2조
        \n
        「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.

        \n
        \n
        1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)\n

          2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)\n

          3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)\n

          4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)\n
        
        \n
        """
    }
    
    @IBAction func touchUpConsentButton(_ sender: Any) {
        if self.consentSwitch.isOn == false {
            self.showBasicAlert(title: "이용 약관에 동의해주세요", message: "슬라이드를 클릭하여 이용약관에 동의할 수 있습니다.")
            return
        }
        UserDefaults.standard.set(consentSwitch.isOn, forKey: "isConsentAgreed")
        goToMainPage()
    }
    
    private func goToMainPage() {
        guard let loginViewController = self.storyboard?.instantiateViewController(
                withIdentifier: LoginViewController.storyboardId) else { return }
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }

}
