//
//  Timer.swift
//  TokamakDemo
//
//  Created by Max Desiatov on 17/02/2019.
//  Copyright © 2019 Max Desiatov. Tokamak is available under the Apache 2.0
//  license. See the LICENSE file for more info.
//

import Foundation
import Tokamak

struct TimerCounter: LeafComponent {
  typealias Props = Null

  static func render(props: Null, hooks: Hooks) -> AnyNode {
    let count = hooks.state(0)
    let timer = hooks.ref(type: Timer.self)
    let interval = hooks.state(1.0)

    hooks.finalizedEffect(interval.value) {
      timer.value = Timer.scheduledTimer(
        withTimeInterval: interval.value,
        repeats: true
      ) { _ in
        count.set { $0 + 1 }
      }
      return {
        timer.value?.invalidate()
      }
    }

    return StackView.node(
      .init(
        Edges.equal(to: .safeArea),
        alignment: .center,
        axis: .vertical,
        distribution: .fillEqually
      ), [
        Label.node(.init(
          alignment: .center,
          text: "Adjust timer interval in seconds: \(interval.value)"
        )),
        Stepper.node(
          .init(
            minimumValue: 1.0,
            value: interval.value,
            valueHandler: Handler(interval.set)
          )
        ),
        Label.node(.init(
          alignment: .center,
          text: "\(count.value) second\(count.value == 1 ? "" : "s") passed"
        )),
      ]
    )
  }
}
