//
//  TagItemView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI
import Charts

struct TagItemView: View {
    let tag: Tag
    
    var body: some View {
        NavigationLink(value: tag) {
            HStack(spacing: 8.0) {
                VStack(alignment: .leading) {
                    Text(tag.name)
                        .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    Text("\(tag.totalUses) uses from \(tag.totalAccounts) users")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
                chart
            }
            .frame(minHeight: 40)
        }
    }
    
    private var chart: some View {
        Chart(tag.history) { history in
            AreaMark(
                x: .value("Day", history.day),
                y: .value("Uses", history.uses)
            )
            .interpolationMethod(.monotone)
            .foregroundStyle(Gradient(colors: [.accentColor, .clear]))
            LineMark(
                x: .value("Day", history.day),
                y: .value("Uses", history.uses)
            )
            .interpolationMethod(.monotone)
        }
        .frame(width: 80, height: 30)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

#Preview {
    NavigationStack {
        List {
            TagItemView(tag: model())
        }
    }
}

