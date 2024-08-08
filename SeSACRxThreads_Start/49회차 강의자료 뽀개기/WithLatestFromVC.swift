//
//  WithLatestFromVC.swift
//  SeSACRxThreads_Start
//
//  Created by 이윤지 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WithLatestFromViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let chalSu = BehaviorSubject(value: "나는 새 영화를 봤어.") //철수
    let girl = BehaviorSubject(value: 12) // 영희의 나이는 처음에 12살

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 색상 설정
        view.backgroundColor = .white

        // UILabel 설정
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)

        // SnapKit을 사용한 레이블 레이아웃 설정
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }

        // 철수가 말할 때마다 영희의 최신 나이를 참고하여 레이블에 표시
        chalSu
            .withLatestFrom(girl)
            .map { age in
                return "철수: 내 이름은 철수야. 영희는 \(age)살이야."
            }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 영희가 몇 번 말합니다.
        girl.onNext(13) // 영희가 "나이는 13살이야"라고 말하고 있음
        girl.onNext(14) // 영희가 "나이는 14살이야"라고 말하고 있음
        
        // 이제 철수가 다시 말할 차례임
        chalSu.onNext("내 이름은 철수야") // 철수가 말함 (영희의 최신 나이는 14살)
    }
}

