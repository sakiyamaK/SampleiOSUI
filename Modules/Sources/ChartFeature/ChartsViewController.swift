//
//  ChartsViewController.swift
//  SampleiOSUI
//
//  Created by  on 2022/7/25.
//

import UIKit
import DeclarativeUIKit
import DGCharts

public final class ChartsViewController: UIViewController {

    public override func loadView() {
        super.loadView()
        setupLayout()
    }
 }

 @objc extension ChartsViewController {

    func setupLayout() {

        let start = 0
        let count = 5

        let yVals = (start ..< start + count + 1).compactMap { i -> BarChartDataEntry in
            let y = Double.random(in: 0...3) + 0.1
            let x = Double(i)
            return BarChartDataEntry(x: x, y: y, icon: nil)
        }

        let MyChartView = {(data: [BarChartDataEntry], color: UIColor, barWidth: CGFloat) -> BarChartView in
            BarChartView().apply {
                $0.leftAxis.enabled = false
                $0.rightAxis.enabled = false
                $0.xAxis.enabled = false
                $0.legend.enabled = false
                $0.fitBars = true
                $0.legend.enabled = false

                let set = BarChartDataSet(entries: yVals, label: "")
                set.colors = [color]
                set.drawValuesEnabled = false

                let data = BarChartData(dataSet: set)
                data.barWidth = barWidth
                $0.data = data
            }

        }

        applyView {
            $0.backgroundColor(.white)
        }.declarative {
            MyChartView(yVals, .blue, 0.4)
                .zStack {
                    MyChartView(yVals, .blue.withAlphaComponent(0.3), 0.4)
                        .offset(x: 24, y: 0)
                }
        }
    }
 }

#Preview {
    ChartsViewController()
}
